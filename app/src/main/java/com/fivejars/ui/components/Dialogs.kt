package com.fivejars.ui.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.sp

enum class DialogType {
    ADD_ACCOUNT, DELETE_ACCOUNT, INCOME,
    DEPOSIT, WITHDRAW, DELETE_USER, EDIT_ACC_NAME,
    EDIT_COEF, EDIT_USER_NAME, EDIT_USER_USERNAME,
    EDIT_USER_PASSWORD
}

@Composable
fun NewAccDialog(currCoefSum: Double, onDismiss: () -> Unit, onSubmit: (String, Double) -> Unit) {
    var newAccountName by remember { mutableStateOf("") }
    var newAccountCoef by remember { mutableStateOf("") }

    // Error flags
    var coefBig by remember { mutableStateOf(false) }


    AlertDialog(
        modifier = Modifier.fillMaxWidth(),
        onDismissRequest = { onDismiss() },
        title = { Text("Add New Account") },
        text = {
            Column {
                OutlinedTextField(
                    value = newAccountName,
                    onValueChange = { newAccountName = it },
                    label = { Text("Account Name") }
                )

                OutlinedTextField(
                    value = newAccountCoef,
                    onValueChange = { input ->
                        if (input.isEmpty()) {
                            newAccountCoef = ""  // This prevents a crash
                        }

                        if (input.toDoubleOrNull() != null) {
                            newAccountCoef = input
                            coefBig = false

                            // If coefficients' sum exceeds 1 display error
                            if (input.toDouble() + currCoefSum > 1) {
                                coefBig = true
                            }
                        }
                    },
                    label = { Text("Account Coefficient") },
                    isError = coefBig
                )
                if (coefBig) {
                    Text("Coefficients' sum exceeds 1", color = Color.Red, fontSize = 12.sp)
                }
            }
        },
        confirmButton = {
            Button(onClick = {
                if (!coefBig) {
                    onSubmit(
                        newAccountName,
                        newAccountCoef.toDoubleOrNull() ?: 0.0
                    )
                }
            }) {
                Text("Confirm")
            }
        },
        dismissButton = {
            Button(onClick = { onDismiss() }) {
                Text("Cancel")
            }
        }
    )
}

@Composable
fun DeleteDialog(onDismiss: () -> Unit, onDelete: () -> Unit) {
    AlertDialog(
        onDismissRequest = { onDismiss() },
        title = { Text("Are you sure?") },
        confirmButton = {
            Button(onClick = {
                onDelete()
            }) {
                Text("Yes")
            }
        },
        dismissButton = {
            Button(onClick = { onDismiss() }) {
                Text("Not really")
            }
        }
    )
}

// For numbers
@Composable
fun SingleInputNumDialog(text: String, onDismiss: () -> Unit, onSubmit: (Double) -> Unit) {
    var sum by remember { mutableStateOf("") }
    AlertDialog(
        onDismissRequest = { onDismiss() },
        title = { Text(text) },
        text = {
            OutlinedTextField(
                value = sum,
                onValueChange = { input ->
                    if (input.toDoubleOrNull() != null || input.isEmpty()) {
                        sum = input
                    }
                },
                label = { Text("Sum") }
            )
        },
        confirmButton = {
            Button(onClick = {
                // Pass sum to submit func
                onSubmit(sum.toDoubleOrNull() ?: 0.0)
            }) {
                Text("Confirm")
            }
        },
        dismissButton = {
            Button(onClick = { onDismiss() }) {
                Text("Cancel")
            }
        }
    )
}

// For text
@Composable
fun SingleInputStringDialog(text: String, onDismiss: () -> Unit, onSubmit: (String) -> Unit) {
    var inputText by remember { mutableStateOf("") }
    AlertDialog(
        onDismissRequest = { onDismiss() },
        title = { Text(text) },
        text = {
            OutlinedTextField(
                value = inputText,
                onValueChange = { input ->
                    inputText = input
                },
                label = { Text("New name") }
            )
        },
        confirmButton = {
            Button(onClick = {
                // Pass name to submit func
                onSubmit(inputText)
            }) {
                Text("Confirm")
            }
        },
        dismissButton = {
            Button(onClick = { onDismiss() }) {
                Text("Cancel")
            }
        }
    )
}

@Composable
fun UpdatePassDialog(currPass: String, onDismiss: () -> Unit, onSubmit: (String, String) -> Unit) {
    var oldPass by remember { mutableStateOf("") }
    var newPass by remember { mutableStateOf("") }
    var confirmPass by remember { mutableStateOf("") }

    AlertDialog(
        onDismissRequest = { onDismiss() },
        title = { Text("Change password") },
        text = {
            Column {
                OutlinedTextField(
                    value = oldPass,
                    label = { Text("Old Password") },
                    keyboardOptions = KeyboardOptions.Default.copy(
                        keyboardType = KeyboardType.Password
                    ),
                    onValueChange = { oldPass = it },
                    visualTransformation = PasswordVisualTransformation()
                )

                OutlinedTextField(
                    value = newPass,
                    onValueChange = { input ->
                        newPass = input
                    },
                    label = { Text("New password") },
                    keyboardOptions = KeyboardOptions.Default.copy(
                        keyboardType = KeyboardType.Password
                    ),
                    visualTransformation = PasswordVisualTransformation()
                )

                OutlinedTextField(
                    value = confirmPass,
                    onValueChange = { input ->
                        confirmPass = input
                    },
                    label = { Text("Confirm new password") },
                    keyboardOptions = KeyboardOptions.Default.copy(
                        keyboardType = KeyboardType.Password
                    ),
                    visualTransformation = PasswordVisualTransformation()
                )
            }
        },
        confirmButton = {
            Button(onClick = {
                if (newPass.isEmpty() || confirmPass.isEmpty() || oldPass.isEmpty()) {
                    onSubmit("", "ERR_EMPTY")
                }

                if (oldPass != currPass) {
                    onSubmit("", "ERR_PASS_MISMATCH")
                }

                if (newPass == confirmPass) {
                    onSubmit(newPass, "OK")
                }
            }) {
                Text("Confirm")
            }
        },
        dismissButton = {
            Button(onClick = { onDismiss() }) {
                Text("Cancel")
            }
        }
    )
}