package com.fivejars.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.fivejars.database.DatabaseClient
import com.fivejars.database.User
import kotlinx.coroutines.launch

@Composable
fun RegisterScreen(navController: NavController) {
    var nickname by remember { mutableStateOf("") }
    var username by remember { mutableStateOf("") }
    var password by remember { mutableStateOf("") }
    var confirm by remember { mutableStateOf("") }

    val scope = rememberCoroutineScope()
    val db = DatabaseClient.getDatabase(context = LocalContext.current)
    var errorMessage by remember { mutableStateOf<String?>(null) }

    fun handleRegister() {
        if (username.isEmpty() || password.isEmpty() || confirm.isEmpty()) {
            errorMessage = "Please fill in all fields."
            return
        }
        if (password != confirm) {
            errorMessage = "Passwords do not match."
            return
        }

        val newUser = User(nickname = nickname, username = username, password = password)
        scope.launch {
            try {
                if (db.userDao().findByUsername(username) != null) {
                    errorMessage = "Another user with this username already exists."
                    return@launch
                }
                db.userDao().insertUser(newUser)
                navController.navigate("login")
            } catch (e: Exception) {
                errorMessage = "Failed to register user:\n${e.message}"
            }
        }
    }

    Column(
        modifier = Modifier.fillMaxSize().padding(16.dp),
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            "Register",
            style = MaterialTheme.typography.headlineMedium,
            modifier = Modifier.padding(bottom = 16.dp)
        )

        OutlinedTextField(
            label = { Text("Nickname") },
            value = nickname,
            onValueChange = { nickname = it }
        )

        OutlinedTextField(
            label = { Text("Username") },
            value = username,
            onValueChange = { username = it }
        )

        OutlinedTextField(
            label = { Text("Password") },
            keyboardOptions = KeyboardOptions.Default.copy(
                keyboardType = KeyboardType.Password
            ),
            value = password,
            onValueChange = { password = it },
            visualTransformation = PasswordVisualTransformation()
        )

        OutlinedTextField(
            label = { Text("Confirm password") },
            keyboardOptions = KeyboardOptions.Default.copy(
                keyboardType = KeyboardType.Password
            ),
            value = confirm,
            onValueChange = { confirm = it },
            visualTransformation = PasswordVisualTransformation()
        )

        Button(
            onClick = { handleRegister() },
            modifier = Modifier.padding(top = 16.dp)
        ) {
            Text("Register")
        }

        errorMessage?.let {
            Spacer(modifier = Modifier.height(8.dp))
            Text(text = it, color = Color.Red)  // Display error message in red
        }

        Button(
            onClick = { navController.navigate("login") },
            modifier = Modifier.padding(top = 16.dp)
        ) {
            Text("Back to Login")
        }
    }
}
