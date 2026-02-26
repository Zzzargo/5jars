package com.zargo.fivejars.spring_api.configs;

import com.zargo.fivejars.spring_api.features.authentication.exceptions.InvalidTokenException;
import com.zargo.fivejars.spring_api.features.authentication.services.JwtService;
import com.zargo.fivejars.spring_api.features.users.exceptions.UserNotFoundException;
import com.zargo.fivejars.spring_api.features.users.models.User;
import com.zargo.fivejars.spring_api.features.users.services.UserService;
import io.jsonwebtoken.Claims;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.jspecify.annotations.NonNull;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerExceptionResolver;

import java.io.IOException;
import java.util.UUID;

@Slf4j
@Component
public class JwtAuthFilter extends OncePerRequestFilter {
    private final JwtService jwtService;
    private final UserService userService;
    private final HandlerExceptionResolver exceptionResolver;

    public JwtAuthFilter(
            final JwtService jwtService,
            final UserService userService,
            final @Qualifier("handlerExceptionResolver") HandlerExceptionResolver exceptionResolver
    ) {
        this.jwtService = jwtService;
        this.userService = userService;
        this.exceptionResolver = exceptionResolver;
    }

    @Override
    protected void doFilterInternal(
            final HttpServletRequest request,
            final @NonNull HttpServletResponse response,
            final @NonNull FilterChain filterChain
    ) throws ServletException, IOException {
        final String authHeader = request.getHeader("Authorization");

        // No token => skip
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
            final String jwt = authHeader.substring(7);  // Start after 'Bearer '
            final String userId = this.jwtService.extractClaim(jwt, Claims::getSubject);

            if (userId != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                final User user = this.userService.getUserById(UUID.fromString(userId));

                if (this.jwtService.isTokenValid(jwt, user)) {
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            user, null, user.getAuthorities()
                    );
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    // Pass the exception to the global exception handler
                    this.exceptionResolver.resolveException(request, response, null, new InvalidTokenException());
                    return;
                }

            }
        } catch (UserNotFoundException e) {
            // Don't let the exception be handled by the global handler, just send a failed auth response (403)
        } catch (Exception e) {
            // Catch any other JWT errors (Expired, Tampered, Malformed)
            log.error("JWT logic failed: {}", e.getMessage());
            this.exceptionResolver.resolveException(request, response, null, new InvalidTokenException());
            return;
        }

        // Note: If validation wasn't successful the filter chain continues and Spring sends a 403
        filterChain.doFilter(request, response);
    }
}
