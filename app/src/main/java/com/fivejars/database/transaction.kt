package com.fivejars.database

import androidx.room.ColumnInfo
import androidx.room.Dao
import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.Insert
import androidx.room.PrimaryKey
import androidx.room.Query

@Entity(
    tableName = "transactions",
    foreignKeys = [
        ForeignKey(
            entity = User::class,
            parentColumns = ["id"],
            childColumns = ["userId"],
            onDelete = ForeignKey.CASCADE
        ),
        ForeignKey(
            entity = Account::class,
            parentColumns = ["id"],
            childColumns = ["accountId"],
            onDelete = ForeignKey.CASCADE
        )
    ]
)
data class Transaction(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "userId", index = true) val userId: Long,
    @ColumnInfo(name = "accountId", index = true) val accountId: Long,
    @ColumnInfo(name = "date") val date: String,
    @ColumnInfo(name = "operation") val operation: String,
    @ColumnInfo(name = "sum") val sum: Double,
    @ColumnInfo(name = "details") val details: String
)

@Dao
interface TransactionDao {
    @Query("SELECT * FROM transactions WHERE userId = :userId")
    suspend fun getUserTransactions(userId: Long): List<Transaction>

    @Insert
    suspend fun newTransaction(trans: Transaction)
}