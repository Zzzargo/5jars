package com.fivejars.database

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Index
import androidx.room.Insert
import androidx.room.Query

@Entity(
    tableName = "users",
    indices = [Index(value = ["username"], unique = true)]
    )
data class User(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    @ColumnInfo(name = "nickname") var nickname: String,
    @ColumnInfo(name = "username") var username: String,
    @ColumnInfo(name = "password") var password: String
)

@Dao
interface UserDao {
    @Query("SELECT * FROM users WHERE username = :username")
    suspend fun findByUsername(username: String): User?

    @Query("SELECT nickname FROM users WHERE id = :id")
    suspend fun getNicknameById(id: Long): String

    @Insert
    suspend fun insertUser(user: User)

    @Delete
    suspend fun deleteUser(user: User)
}