package com.fivejars.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.ExitToApp
import androidx.compose.material.icons.filled.MoreVert
import androidx.compose.material.icons.outlined.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import com.fivejars.database.*
import com.fivejars.viewmodels.UserViewModel
import kotlinx.coroutines.launch

import com.fivejars.ui.components.*

@Composable
fun AccountCard(
    account: Account,
    onDeposit: () -> Unit,
    onWithdraw: () -> Unit,
    onDelete: () -> Unit,
    onEditName: () -> Unit,
    onEditCoef: () -> Unit
) {
    var optionsExpanded by remember { mutableStateOf(false) }

    Card(
        modifier = Modifier
            .fillMaxWidth(),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
        elevation = CardDefaults.cardElevation(4.dp)
    ) {
        Column(
            modifier = Modifier
                .padding(16.dp),
            verticalArrangement = Arrangement.spacedBy(10.dp)
        ) {
            Text("${account.name}: ${(account.coefficient * 100).toInt()}%", style = MaterialTheme.typography.titleMedium)
            Text("Balance: ${account.balance} RON", style = MaterialTheme.typography.bodyLarge)

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                Button(
                    onClick = { onDeposit() },
                    colors = ButtonDefaults.buttonColors(MaterialTheme.colorScheme.primary)
                ) {
                    Text("Deposit")
                }
                Button(
                    onClick = { onWithdraw() },
                    colors = ButtonDefaults.buttonColors(MaterialTheme.colorScheme.secondary)
                ) {
                    Text("Withdraw")
                }

                // Dropdown menu for more options
                Box {
                    IconButton(
                        onClick = { optionsExpanded = true },
                        modifier = Modifier
                            .background(MaterialTheme.colorScheme.tertiary, shape = CircleShape)
                            .clip(CircleShape)
                    ) {
                        Icon(Icons.Default.MoreVert, contentDescription = "More options")
                    }

                    DropdownMenu(
                        expanded = optionsExpanded,
                        onDismissRequest = { optionsExpanded = false }
                    ) {
                        DropdownMenuItem(
                            text = { Text("Rename account") },
                            leadingIcon = { Icon(Icons.Outlined.Edit, contentDescription = null) },
                            onClick = {
                                onEditName()
                                optionsExpanded = false
                            }
                        )
                        DropdownMenuItem(
                            text = { Text("Change coefficient") },
                            leadingIcon = { Icon(Icons.Outlined.Build, contentDescription = null) },
                            onClick = {
                                onEditCoef()
                                optionsExpanded = false
                            }
                        )
                        HorizontalDivider()
                        DropdownMenuItem(
                            text = { Text("Delete account") },
                            leadingIcon = { Icon(Icons.Outlined.Delete, contentDescription = null) },
                            onClick = {
                                onDelete()
                                optionsExpanded = false
                            }
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun DashboardScreen(navController: NavController, userViewModel: UserViewModel) {
    val user by userViewModel.loggedInUser.collectAsState()  // Get current user
    val db = DatabaseClient.getDatabase(context = LocalContext.current)
    var accounts by remember { mutableStateOf<List<Account>>(emptyList()) }
    var nickname by remember { mutableStateOf(user?.nickname ?: "Unknown") }
    val scope = rememberCoroutineScope()

    val snackbarHostState = remember { SnackbarHostState() }

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
                        "Control panel",
                        modifier = Modifier.padding(16.dp),
                        style = MaterialTheme.typography.titleLarge
                    )

                    HorizontalDivider()

                    NavigationDrawerItem(
                        label = { Text("Add account") },
                        icon = { Icon(Icons.Outlined.Add, contentDescription = null) },
                        selected = false,
                        onClick = { activeDialog = DialogType.ADD_ACCOUNT }
                    )

                    NavigationDrawerItem(
                        label = { Text("Change name") },
                        selected = false,
                        icon = { Icon(Icons.Outlined.Person, contentDescription = null) },
                        onClick = { activeDialog = DialogType.EDIT_USER_NAME }
                    )

                    HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

                    NavigationDrawerItem(
                        label = { Text("Change username") },
                        selected = false,
                        icon = { Icon(Icons.Outlined.Edit, contentDescription = null) },
                        onClick = { activeDialog = DialogType.EDIT_USER_USERNAME }
                    )

                    NavigationDrawerItem(
                        label = { Text("Change password") },
                        selected = false,
                        icon = { Icon(Icons.Outlined.Lock, contentDescription = null) },
                        onClick = { activeDialog = DialogType.EDIT_USER_PASSWORD }
                    )

                    NavigationDrawerItem(
                        label = { Text("Delete user account") },
                        selected = false,
                        icon = { Icon(Icons.Outlined.Delete, contentDescription = null) },
                        onClick = { activeDialog = DialogType.DELETE_USER }
                    )

                    HorizontalDivider(modifier = Modifier.padding(vertical = 8.dp))

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
        Scaffold(
            modifier = Modifier.imePadding(),
            snackbarHost = { SnackbarHost(hostState = snackbarHostState) }
        ) { innerPadding ->
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(0.dp)
                    .background(MaterialTheme.colorScheme.background)
            ) {
                Column(
                    modifier = Modifier
                        .fillMaxSize()
                        .padding(innerPadding)
                        .background(MaterialTheme.colorScheme.background),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Spacer(Modifier.height(12.dp))
                    Text(
                        "Hi, $nickname!",
                        style = MaterialTheme.typography.titleLarge,
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

//                    Button(
//                        onClick = {  },
//                    ) {
//                        Text("Shared op2")
//                    }
                    }
                    Spacer(Modifier.height(12.dp))

                    Text("Total: ${accounts.sumOf { it.balance }} RON")
                    Spacer(Modifier.height(12.dp))

                    LazyColumn(
                        modifier = Modifier
                            .padding(horizontal = 20.dp),
                        verticalArrangement = Arrangement.spacedBy(12.dp)
                    ) {
                        items(accounts.sortedByDescending { it.coefficient }) { account ->
                            AccountCard(
                                account,
                                onDelete = {
                                    activeDialog = DialogType.DELETE_ACCOUNT
                                    currentAccount = account.id
                                },
                                onDeposit = {
                                    activeDialog = DialogType.DEPOSIT
                                    currentAccount = account.id
                                },
                                onWithdraw = {
                                    activeDialog = DialogType.WITHDRAW
                                    currentAccount = account.id
                                },
                                onEditName = {
                                    activeDialog = DialogType.EDIT_ACC_NAME
                                    currentAccount = account.id
                                },
                                onEditCoef = {
                                    activeDialog = DialogType.EDIT_COEF
                                    currentAccount = account.id
                                }
                            )
                        }
                    }
                }
            }
        }
    }

    when (activeDialog) {
        DialogType.ADD_ACCOUNT -> {
            NewAccDialog(
                currCoefSum = accounts.sumOf { it.coefficient },
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
            DeleteDialog(onDismiss = { activeDialog = null },
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

        DialogType.DELETE_USER -> {
            DeleteDialog(
                onDismiss = { activeDialog = null },
                onDelete = {
                    scope.launch {
                        db.userDao().deleteUser(user!!)
                        userViewModel.logout()
                        activeDialog = null // close dialog
                        navController.navigate("login")
                    }
                }
            )
        }

        DialogType.INCOME -> {
            SingleInputNumDialog(
                text = "Shared Income",
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

        DialogType.DEPOSIT -> {
            SingleInputNumDialog(
                text = "Deposit to ${accounts.find { it.id == currentAccount }!!.name}",
                onDismiss = { activeDialog = null },
                onSubmit = { sum ->
                    scope.launch {
                        db.accountDao().deposit(currentAccount, sum)

                        // Refresh UI
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null // close dialog
                    }
                }
            )
        }

        DialogType.WITHDRAW -> {
            SingleInputNumDialog(
                text = "Withdraw from ${accounts.find { it.id == currentAccount }!!.name}",
                onDismiss = { activeDialog = null },
                onSubmit = { sum ->
                    scope.launch {
                        db.accountDao().withdraw(currentAccount, sum)

                        // Refresh UI
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null // close dialog
                    }
                }
            )
        }

        DialogType.EDIT_USER_NAME -> {
            SingleInputStringDialog(
                "New nickname",
                onDismiss = { activeDialog = null },
                onSubmit = { name ->
                    scope.launch {
                        if (name.isEmpty()) {
                            snackbarHostState.showSnackbar("Name cannot be empty")
                            return@launch
                        }
                        db.userDao().updateNickname(user!!.id, name)

                        // Refresh UI
                        nickname = name
                        activeDialog = null
                        snackbarHostState.showSnackbar("Nickname updated")
                    }
                }
            )
        }

        DialogType.EDIT_ACC_NAME -> {
            SingleInputStringDialog(
                "New name for account ${ accounts.find { it.id == currentAccount }!!.name }",
                onDismiss = { activeDialog = null },
                onSubmit = { name ->
                    scope.launch {
                        if (name.isEmpty()) {
                            snackbarHostState.showSnackbar("Name cannot be empty")
                            return@launch
                        }
                        db.accountDao().updateName(currentAccount, name)

                        // Refresh accounts list
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null
                        snackbarHostState.showSnackbar("Account name updated")
                    }
                }
            )
        }

        DialogType.EDIT_COEF -> {
            SingleInputNumDialog(
                text = "New coefficient for account ${ accounts.find { it.id == currentAccount }!!.name }",
                onDismiss = { activeDialog = null },
                onSubmit = { coef ->
                    scope.launch {
                        val coefSum = accounts.sumOf { it.coefficient } - accounts.find { it.id == currentAccount }!!.coefficient
                        if (coefSum + coef > 1) {
                            snackbarHostState.showSnackbar("Coefficient sum exceeds 1")
                            return@launch
                        }
                        db.accountDao().updateCoefficient(currentAccount, coef)

                        // Refresh accounts list
                        accounts = db.accountDao().getUserAccounts(user!!.id)
                        activeDialog = null
                        snackbarHostState.showSnackbar("Coefficient updated")
                    }
                }
            )
        }

        DialogType.EDIT_USER_USERNAME -> {
            SingleInputStringDialog(
                "New username",
                onDismiss = { activeDialog = null },
                onSubmit = { name ->
                    scope.launch {
                        if (name.isEmpty()) {
                            snackbarHostState.showSnackbar("Name cannot be empty")
                            return@launch
                        }
                        db.userDao().updateUsername(user!!.id, name)

                        // Refresh UI
                        activeDialog = null
                        snackbarHostState.showSnackbar("Username updated")
                    }
                }
            )
        }

        DialogType.EDIT_USER_PASSWORD -> {
            UpdatePassDialog(
                currPass =  user!!.password,
                onDismiss = { activeDialog = null },
                onSubmit = { newPass, msg ->
                    scope.launch {
                        when (msg) {
                            "OK" -> {
                                db.userDao().updatePassword(user!!.id, newPass)

                                // Refresh UI
                                activeDialog = null
                                snackbarHostState.showSnackbar("Password updated")
                            }
                            "ERR_EMPTY" -> {
                                snackbarHostState.showSnackbar("Please fill in all fields")
                            }
                            "ERR_PASS_MISMATCH" -> {
                                snackbarHostState.showSnackbar("Passwords do not match")
                            }
                        }
                    }
                }
            )
        }

        null -> {}  // Close dialog
    }
}