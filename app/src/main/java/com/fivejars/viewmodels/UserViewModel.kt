package com.fivejars.viewmodels

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.fivejars.database.User
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.launch

class UserViewModel : ViewModel() {
    // Mutable state to hold the logged-in user
    private var _loggedInUser = MutableStateFlow<User?>(null)
    val loggedInUser: StateFlow<User?> = _loggedInUser  // Public read-only version

    // Function to set the logged-in user
    fun setCurrUser(user: User) {
        viewModelScope.launch {
            _loggedInUser.value = user
        }
    }

    // Function to clear user when logging out
    fun logout() {
        viewModelScope.launch {
            _loggedInUser.value = null
        }
    }
}
