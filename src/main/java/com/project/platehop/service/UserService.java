package com.project.platehop.service;

import java.sql.Timestamp;
import java.util.List;
import java.util.Optional;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.project.platehop.model.User;
import com.project.platehop.repository.UserRepository;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    public User addUser(User user) {
        if (user.getPassword() != null && !user.getPassword().startsWith("$2a$")) {
            user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12)));
        }
        if (user.getCreatedDate() == null) {
            user.setCreatedDate(new Timestamp(System.currentTimeMillis()));
        }
        if (user.getRole() == null || user.getRole().trim().isEmpty()) {
            user.setRole("customer");
        }
        return userRepository.save(user);
    }

    public User registerUser(String userName, String email, String rawPassword, String address, String role) {
        if (role == null || role.trim().isEmpty()) {
            role = "customer";
        } else {
            role = role.trim().toLowerCase();
        }

        String hashedPassword = BCrypt.hashpw(rawPassword, BCrypt.gensalt(12));
        User user = new User(userName, email, hashedPassword, address, role);
        return userRepository.save(user);
    }

    public User loginUser(String email, String rawPassword) {
        Optional<User> optUser = userRepository.findByEmail(email);
        if (optUser.isEmpty()) {
            return null;
        }

        User user = optUser.get();
        boolean passwordMatch = false;

        String storedPassword = user.getPassword();
        if (storedPassword != null) {
            if (storedPassword.startsWith("$2a$") || storedPassword.startsWith("$2b$") || storedPassword.startsWith("$2y$")) {
                try {
                    passwordMatch = BCrypt.checkpw(rawPassword, storedPassword);
                } catch (Exception e) {
                    passwordMatch = false;
                }
            } else {
                // Fallback for any legacy plain text passwords in the database
                passwordMatch = storedPassword.equals(rawPassword);
                if (passwordMatch) {
                    // Upgrade to BCrypt
                    user.setPassword(BCrypt.hashpw(rawPassword, BCrypt.gensalt(12)));
                }
            }
        }

        if (passwordMatch) {
            user.setLastLoginDate(new Timestamp(System.currentTimeMillis()));
            userRepository.save(user);
            return user;
        }

        return null;
    }

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(int id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User updateUser(User user) {
        user.setLastLoginDate(new Timestamp(System.currentTimeMillis()));
        return userRepository.save(user);
    }

    public void deleteUser(int id) {
        userRepository.deleteById(id);
    }
}
