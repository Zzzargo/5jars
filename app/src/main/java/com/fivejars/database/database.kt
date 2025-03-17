package com.fivejars.database

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.Room
import android.content.Context

@Database(entities = [User::class, Account::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao
    abstract fun accountDao(): AccountDao
}

object DatabaseClient {
    private var appDatabase: AppDatabase? = null

    fun getDatabase(context: Context): AppDatabase {
        if (appDatabase == null) {
            appDatabase = Room.databaseBuilder(
                context.applicationContext,
                AppDatabase::class.java,
                "app_database",
            )
                .fallbackToDestructiveMigration()
                .build()
        }
        return appDatabase!!
    }
}