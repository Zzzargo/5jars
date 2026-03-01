package com.zargo.fivejars.spring_api.features.authentication.services;

import com.zargo.fivejars.spring_api.features.users.models.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import io.jsonwebtoken.Jwts;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.function.Function;

@Service
public class JwtService {
    @Value("${app.security.jwt.secret-key}")
    private String secretKey;

    @Value("${app.security.jwt.expiration}")
    private long jwtExpiration;

    public String generateToken(final User user) {
        return Jwts.builder()
                .subject(user.getId().toString())  // Use the UUID as a String as jwt subject
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + jwtExpiration))
                .signWith(getJwtSigningKey())
                .compact();
    }

    public <R> R extractClaim(final String token, final Function<Claims, R> claimsResolver) {
        return claimsResolver.apply(extractAllClaims(token));
    }

    private Claims extractAllClaims(final String token) {
        return Jwts.parser()
                .verifyWith(getJwtSigningKey())
                .build()
                .parseSignedClaims(token)
                .getPayload();
    }

    private SecretKey getJwtSigningKey() {
        byte[] keyBytes = Decoders.BASE64.decode(secretKey);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public boolean isTokenValid(final String token, final User user) {
        final String uuidString = extractClaim(token, Claims::getSubject);
        return (uuidString.equals(user.getId().toString()) && !isTokenExpired(token));
    }

    private boolean isTokenExpired(final String token) {
        return extractClaim(token, Claims::getExpiration).before(new Date());  // Compare to current date
    }
}
