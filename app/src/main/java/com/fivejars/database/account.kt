package com.fivejars.database

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.ForeignKey
import androidx.room.Dao
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

    @Insert
    suspend fun newAccount(account: Account)
}