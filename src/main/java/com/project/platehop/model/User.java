package com.project.platehop.model;

import java.io.Serializable;
import java.sql.Timestamp;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "user")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userId")
    private int userId;

    @Column(name = "name")
    private String name;

    @Column(name = "userName")
    private String userName;

    @Column(name = "email", nullable = false, unique = true)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "phone")
    private String phone;

    @Column(name = "address")
    private String address;

    @Column(name = "role")
    private String role = "customer";

    @Column(name = "createdDate")
    private Timestamp createdDate;

    @Column(name = "lastLoginDate")
    private Timestamp lastLoginDate;

    public User() {
    }

    public User(int userId, String userName, String email, String password, String address, String role,
                Timestamp createdDate, Timestamp lastLoginDate) {
        this.userId = userId;
        this.userName = userName;
        this.name = userName;
        this.email = email;
        this.password = password;
        this.address = address;
        this.role = role;
        this.createdDate = createdDate;
        this.lastLoginDate = lastLoginDate;
    }

    public User(String userName, String email, String password, String address, String role) {
        this.userName = userName;
        this.name = userName;
        this.email = email;
        this.password = password;
        this.address = address;
        this.role = role;
        this.createdDate = new Timestamp(System.currentTimeMillis());
        this.lastLoginDate = new Timestamp(System.currentTimeMillis());
    }

    public int getId() {
        return userId;
    }

    public void setId(int id) {
        this.userId = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        if (name != null && !name.trim().isEmpty()) {
            return name;
        }
        return userName;
    }

    public void setName(String name) {
        this.name = name;
        if (this.userName == null) {
            this.userName = name;
        }
    }

    public String getUserName() {
        if (userName != null && !userName.trim().isEmpty()) {
            return userName;
        }
        return name;
    }

    public void setUserName(String userName) {
        this.userName = userName;
        if (this.name == null) {
            this.name = userName;
        }
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Timestamp getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Timestamp createdDate) {
        this.createdDate = createdDate;
    }

    public Timestamp getLastLoginDate() {
        return lastLoginDate;
    }

    public void setLastLoginDate(Timestamp lastLoginDate) {
        this.lastLoginDate = lastLoginDate;
    }

    @Override
    public String toString() {
        return "User [userId=" + userId + ", name=" + getName() + ", email=" + email + ", role=" + role + "]";
    }
}