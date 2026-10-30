
package com.tap.controller;

import java.io.IOException;

import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/register.jsp");

        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword =
                request.getParameter("confirmPassword");
        String terms = request.getParameter("terms");

        // Validate required fields
        if (isBlank(username)
                || isBlank(email)
                || isBlank(phone)
                || isBlank(password)
                || isBlank(confirmPassword)
                || terms == null) {

            forwardWithError(request, response,
                    "Please fill in all required fields.");
            return;
        }

        username = username.trim();
        email = email.trim();
        phone = phone.trim();

        // Validate registration details
        if (username.length() > 100
                || email.length() > 150
                || !email.matches(
                    "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
                || !phone.matches("[0-9]{10}")
                || password.length() < 8
                || password.length() > 72) {

            forwardWithError(request, response,
                    "Please enter valid details. "
                    + "Password must contain 8 to 72 characters.");
            return;
        }

        // Confirm password
        if (!password.equals(confirmPassword)) {
            forwardWithError(request, response,
                    "Passwords do not match.");
            return;
        }

        try {
            // Check whether the email already exists
            User existingUser = userDao.getUserByEmail(email);

            if (existingUser != null) {
                forwardWithError(request, response,
                        "This email is already registered. Please log in.");
                return;
            }

            // Hash the password using BCrypt (trainer's version)
            String hashedPassword =
                    BCrypt.hashpw(password, BCrypt.gensalt());

            // Create the user
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPhone(phone);
            user.setPassword(hashedPassword);
            user.setAddress("");
            user.setRole("customer");

            // Save the user with the hashed password
            userDao.addUser(user);

            // Retrieve the saved user, including the generated userId
            User registeredUser = userDao.getUserByEmail(email);

            if (registeredUser == null) {
                forwardWithError(request, response,
                        "Account created, but automatic login failed. "
                        + "Please log in.");
                return;
            }

            // Log in the user automatically
            HttpSession session = request.getSession();
            session.setAttribute("user", registeredUser);
            session.setAttribute("userId", registeredUser.getUserId());

            // Open the restaurants page
            response.sendRedirect(
                    request.getContextPath() + "/restaurant");

        } catch (RuntimeException exception) {

            getServletContext().log(
                    "Registration failed.", exception);

            forwardWithError(request, response,
                    "Registration failed. Please try again.");
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void forwardWithError(HttpServletRequest request,
                                  HttpServletResponse response,
                                  String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);

        RequestDispatcher dispatcher =
                request.getRequestDispatcher("/register.jsp");

        dispatcher.forward(request, response);
    }
}
