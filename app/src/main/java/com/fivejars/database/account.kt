package com.fivejars.database

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.ForeignKey
import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.Query

@Entity(
    tableName = "accounts",
    foreignKeys = [
        ForeignKey(
            entity = User::class,
            parentColumns = ["id"],
            childColumns = ["ownerId"],
            onDelete = ForeignKey.CASCADE
        )
    ]
)
data class Account(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "ownerId", index = true)
    val ownerId: Long,

    @ColumnInfo(name = "name") var name: String,
    @ColumnInfo(name = "balance") var balance: Double,
    @ColumnInfo(name = "coefficient") var coefficient: Double
)

@Dao
interface AccountDao {
    @Query("SELECT * FROM accounts WHERE ownerId = :ownerId")
    suspend fun getUserAccounts(ownerId: Long): List<Account>

    @Query("SELECT * FROM accounts WHERE id = :id")
    suspend fun getAccountById(id: Long): Account

    @Insert
    suspend fun newAccount(account: Account)

    @Delete
    suspend fun deleteAccount(account: Account)

    // Add a corresponding fraction of the sum to each account based on the coefficient
    @Query("""
        UPDATE accounts
        SET balance = balance + (:sum * coefficient)
        WHERE ownerId = :ownerId
    """)
    suspend fun sharedIncome(ownerId: Long, sum: Double)

    @Query("UPDATE accounts SET balance = balance + :sum WHERE id = :id")
    suspend fun deposit(id: Long, sum: Double)

    @Query("UPDATE accounts SET balance = balance - :sum WHERE id = :id")
    suspend fun withdraw(id: Long, sum: Double)

    @Query("UPDATE accounts SET coefficient = :coefficient WHERE id = :id")
    suspend fun updateCoefficient(id: Long, coefficient: Double)

    @Query("UPDATE accounts SET name = :name WHERE id = :id")
    suspend fun updateName(id: Long, name: String)

}