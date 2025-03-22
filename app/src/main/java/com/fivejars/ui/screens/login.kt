package com.fivejars.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.fivejars.database.*
import com.fivejars.viewmodels.UserViewModel
import kotlinx.coroutines.launch

@Composable
fun LoginScreen(navController: NavController, userViewModel: UserViewModel) {
    var username by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }

    val db = DatabaseClient.getDatabase(context = LocalContext.current)
    var userFound by remember { mutableStateOf<User?>(null) }
    val scope = rememberCoroutineScope()

    // For errors
    val snackbarHostState = remember { SnackbarHostState() }

    fun handleLogin() {
        scope.launch {
            if (username.isEmpty() || password.isEmpty()) {
                snackbarHostState.showSnackbar("Please fill in all fields.")
                return@launch
            }

            // Query the database for the user
            userFound = db.userDao().findByUsername(username)
            if (userFound != null) {
                // Separated the checks for different error messages
                if (userFound!!.password == password) {
                    // Set current user and go to dashboard
                    userViewModel.setCurrUser(userFound!!)
                    navController.navigate("dashboard")
                } else {
                    snackbarHostState.showSnackbar("Incorrect password")
                }
            } else {
                // Show error if login fails
                snackbarHostState.showSnackbar("User not found")
            }
        }
    }

    /* UI */
    Scaffold(
        snackbarHost = { SnackbarHost(hostState = snackbarHostState) }
    ) { contentPadding ->
        Column(
            modifier = Modifier.fillMaxSize().padding(contentPadding),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        )
        {
            Text(
                "Welcome to Five Jars!",
                modifier = Modifier.padding(20.dp),
                style = MaterialTheme.typography.headlineMedium
            )

            OutlinedTextField(
                value = username,
                onValueChange = { username = it },
                label = { Text("Username") },
            )

            OutlinedTextField(
                value = password,
                keyboardOptions = KeyboardOptions.Default.copy(
                    keyboardType = KeyboardType.Password
                ),
                onValueChange = { password = it },
                label = { Text("Password") },
                visualTransformation = PasswordVisualTransformation(),
                modifier = Modifier.padding(top = 8.dp)
            )

            Button(
                onClick = { handleLogin() },
                modifier = Modifier.padding(top = 16.dp)
            ) {
                Text("Login")
            }

            TextButton(
                onClick = { navController.navigate("register") },
                modifier = Modifier.padding(top = 8.dp)
            ) {
                Text("Register")
            }
        }
    }
}
