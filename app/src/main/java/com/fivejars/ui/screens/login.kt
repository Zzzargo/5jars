package com.fivejars.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardCapitalization
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

    var userFound by remember { mutableStateOf<User?>(null) }
    var errorMessage by remember { mutableStateOf<String?>(null) }
    val scope = rememberCoroutineScope()
    val db = DatabaseClient.getDatabase(context = LocalContext.current)

    fun handleLogin() {
        scope.launch {
            // Query the database for the user
            userFound = db.userDao().findByUsername(username)
            if (userFound != null && userFound?.password == password) {
                // Set current user and go to dashboard
                userViewModel.setCurrUser(userFound!!)
                navController.navigate("dashboard")
            } else {
                // Show error if login fails
                errorMessage = "Invalid credentials, please try again."
            }
        }
    }

    /* UI */
    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
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

        errorMessage?.let {
            Spacer(modifier = Modifier.height(8.dp))
            Text(text = it, color = Color.Red)  // Display error message in red
        }
    }
}
