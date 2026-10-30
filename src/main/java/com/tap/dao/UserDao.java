package com.tap.dao;

import com.tap.model.User;
import java.util.List;

public interface UserDao {

    void addUser(User user);
    
    User getUserByEmail(String useEmail);

    User getUser(int userId);

    void updateUser(User user);

    void deleteUser(int userId);

    List<User> getAllUsers();
}