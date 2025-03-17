package com.fivejars

import com.fivejars.ui.screens.*

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
//import androidx.compose.foundation.layout.fillMaxSize
//import androidx.compose.foundation.layout.padding
//import androidx.compose.material3.Scaffold
//import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.remember
//import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import com.fivejars.ui.theme.FiveJarsTheme
import com.fivejars.viewmodels.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            val userViewModel = remember { UserViewModel() }
            FiveJarsTheme {
                FiveJarsApp(userViewModel)
            }
        }
    }
}

@Composable
fun FiveJarsApp(userViewModel: UserViewModel) {
    val navController = rememberNavController()

    NavHost(navController = navController, startDestination = "login") {
        composable("login") { LoginScreen(navController, userViewModel) }
        composable("register") { RegisterScreen(navController) }
        composable("dashboard") { DashboardScreen(navController, userViewModel) }
    }
}