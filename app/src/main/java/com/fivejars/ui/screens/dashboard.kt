package com.fivejars.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.ArrowBack
import androidx.compose.material.icons.automirrored.outlined.ExitToApp
import androidx.compose.material.icons.automirrored.outlined.Send
import androidx.compose.material.icons.filled.Menu
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.fivejars.database.*
import com.fivejars.viewmodels.UserViewModel
import kotlinx.coroutines.launch

// There will be plenty of dialogs
enum class DialogType {
    ADD_ACCOUNT, DELETE_ACCOUNT, INCOME, WITHDRAW, OPTIONS
}

@Composable
fun AccountCard(
    account: Account,
//    onDeposit: () -> Unit,
//    onWithdraw: () -> Unit,
    onDelete: () -> Unit
) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        elevation = CardDefaults.cardElevation(4.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Text(account.name, style = MaterialTheme.typography.titleMedium)
            Text("Balance: ${account.balance} RON", style = MaterialTheme.typography.bodyLarge)

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Button(onClick = {}, colors = ButtonDefaults.buttonColors(MaterialTheme.colorScheme.primary)) {
                    Text("Deposit")
                }
                Button(onClick = {}, colors = ButtonDefaults.buttonColors(MaterialTheme.colorScheme.secondary)) {
                    Text("Withdraw")
                }
                Button(onClick = { onDelete() }, colors = ButtonDefaults.buttonColors(MaterialTheme.colorScheme.error)) {
                    Text("Delete")
                }
            }
        }
    }
}

@Composable
fun NewAccDialog(onDismiss: () -> Unit, onSubmit: (String, Double) -> Unit) {
    var newAccountName by remember { mutableStateOf("") }
    var newAccountCoef by remember { mutableStateOf("") }
    AlertDialog(
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
                        if (input.toDoubleOrNull() != null || input.isEmpty()) {
                            newAccountCoef = input
                        }
                    },
                    label = { Text("Account Coefficient") }
                )
            }
        },
        confirmButton = {
            Button(onClick = {
                onSubmit(
                    newAccountName,
                    newAccountCoef.toDoubleOrNull() ?: 0.0
                )
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
fun DeleteAccDialog(onDismiss: () -> Unit, onDelete: () -> Unit) {
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

@Composable
fun IncomeDialog(onDismiss: () -> Unit, onSubmit: (Double) -> Unit) {
    var sum by remember { mutableStateOf("") }
    AlertDialog(
        onDismissRequest = { onDismiss() },
        title = { Text("Shared Income") },
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

@Composable
fun DashboardScreen(navController: NavController, userViewModel: UserViewModel) {
    val user by userViewModel.loggedInUser.collectAsState()  // Get current user
    val db = DatabaseClient.getDatabase(context = LocalContext.current)
    var accounts by remember { mutableStateOf<List<Account>>(emptyList()) }
    var nickname = user?.nickname ?: "Unknown"
    val scope = rememberCoroutineScope()

    // Fetch some initial data from the database
    LaunchedEffect(user) {
        user?.let {
            accounts = db.accountDao().getUserAccounts(it.id)
            nickname = db.userDao().getNicknameById(it.id)
        }
    }

    var activeDialog by remember { mutableStateOf<DialogType?>(null) }
    // Will hold an account that is currently selected
    var currentAccount by remember { mutableLongStateOf(-1) }

    // Wrap content in drawer func
    val drawerState = rememberDrawerState(initialValue = DrawerValue.Closed)
    ModalNavigationDrawer(
        drawerState = drawerState,
        drawerContent = {
            ModalDrawerSheet {
                Column(
                    modifier = Modifier
                        .padding(horizontal = 16.dp)
                        .verticalScroll(rememberScrollState())
                ) {
                    Spacer(Modifier.height(12.dp))
                    Text(
                        "Admin panel",
                        modifier = Modifier.padding(16.dp),
                        style = MaterialTheme.typography.titleLarge
                    )

                    HorizontalDivider()

                    NavigationDrawerItem(
                        label = { Text("Add account") },
                        selected = false,
                        onClick = { activeDialog = DialogType.ADD_ACCOUNT }
                    )
                    NavigationDrawerItem(
                        label = { Text("Delete user account") },
                        selected = false,
                        onClick = { /* Handle click */ }
                    )

                    HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

                    Text(
                        "Section 2",
                        modifier = Modifier.padding(16.dp),
                        style = MaterialTheme.typography.titleLarge
                    )
                    NavigationDrawerItem(
                        label = { Text("Settings") },
                        selected = false,
                        icon = { Icon(Icons.Outlined.Settings, contentDescription = null) },
                        badge = { Text("20") }, // Placeholder
                        onClick = { /* Handle click */ }
                    )
                    NavigationDrawerItem(
                        label = { Text("Log out") },
                        selected = false,
                        icon = {
                            Icon(
                                Icons.AutoMirrored.Outlined.ExitToApp,
                                contentDescription = null
                            )
                        },
                        onClick = {
                            userViewModel.logout()
                            navController.navigate("login")
                        },
                    )
                    Spacer(Modifier.height(12.dp))
                }
            }
        }
    ) {
        Scaffold() { innerPadding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding)  // Use innerPadding from Scaffold
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Text(
                    "Hi, $nickname!",
                    style = MaterialTheme.typography.headlineMedium,
                )
                Spacer(Modifier.height(12.dp))

                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly,
                ) {
                    Button(
                        onClick = { activeDialog = DialogType.INCOME },
                    ) {
                        Text("Shared Income")
                    }

                    Button(
                        onClick = {  },
                    ) {
                        Text("Shared op2")
                    }
                }
                Spacer(Modifier.height(12.dp))

                Text("Total: ${accounts.sumOf { it.balance }} RON")
                Spacer(Modifier.height(12.dp))

                LazyColumn(
                    modifier = Modifier.fillMaxSize(),
                    verticalArrangement = Arrangement.spacedBy(8.dp)
                ) {
                    items(accounts) { account ->
                        AccountCard(
                            account,
                            onDelete = {
                                activeDialog = DialogType.DELETE_ACCOUNT
                                currentAccount = account.id
                            }
                        )
                    }
                }
            }
        }
    }

    when (activeDialog) {
        DialogType.ADD_ACCOUNT -> {
            NewAccDialog(
                onDismiss = { activeDialog = null },
                onSubmit = { name, coef ->
                    // Add new account to database
                    scope.launch {
                        val newAccount = Account(
                            ownerId = user!!.id,
                            balance = 0.0,
                            name = name,
                            coefficient = coef
                        )
                        db.accountDao().newAccount(newAccount)
                        // Refresh UI
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null  // close dialog
                    }
                }
            )
        }

        DialogType.DELETE_ACCOUNT -> {
            DeleteAccDialog(onDismiss = { activeDialog = null },
                onDelete = {
                    scope.launch {
                        val acc = db.accountDao().getAccountById(currentAccount)
                        db.accountDao().deleteAccount(acc)

                        // Refresh UI
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null // close dialog
                    }
                }
            )
        }
        DialogType.INCOME -> {
            IncomeDialog(
                onDismiss = { activeDialog = null },
                onSubmit = { sum ->
                    scope.launch {
                        // Add a fraction of the sum to each account
                        db.accountDao().sharedIncome(user!!.id, sum)

                        // Refresh UI
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null // close dialog
                    }
                }
            )
        }
        DialogType.WITHDRAW -> {}
        DialogType.OPTIONS -> {}
        null -> {}
    }
}