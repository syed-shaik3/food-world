
package com.tap.controller;

import java.io.IOException;


import org.mindrot.jbcrypt.BCrypt;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;
import com.tap.model.Cart;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    // Open the login page
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/login.jsp");
    }

    // Process login form
    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp?error=invalid");
            return;
        }

        try {
            // Find user using email
            User user = userDao.getUserByEmail(email.trim());

            // Check whether user exists and has a stored password hash
            if (user == null || user.getPassword() == null) {
                resp.sendRedirect(
                        req.getContextPath() + "/login.jsp?error=invalid");
                return;
            }

            // Verify entered password against the BCrypt hash
            boolean passwordMatches;

            try {
                passwordMatches =
                        BCrypt.checkpw(password, user.getPassword());
            } catch (IllegalArgumentException exception) {
                // Stored password is not a valid BCrypt hash
                passwordMatches = false;
            }

            if (!passwordMatches) {
                resp.sendRedirect(
                        req.getContextPath() + "/login.jsp?error=invalid");
                return;
            }

            // Preserve the cart before replacing the session
            HttpSession oldSession = req.getSession(false);
            Cart cart = null;

            if (oldSession != null) {
                cart = (Cart) oldSession.getAttribute("cart");
                oldSession.invalidate();
            }

            // Create a fresh session after successful authentication
            HttpSession session = req.getSession(true);

            // Restore the cart
            if (cart != null) {
                session.setAttribute("cart", cart);
            }

            // Store logged-in user details
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());

            // Continue checkout if the cart has items
            if (cart != null && !cart.isEmpty()) {
                resp.sendRedirect(
                        req.getContextPath() + "/checkout");
            } else {
                resp.sendRedirect(
                        req.getContextPath() + "/restaurant");
            }

        } catch (Exception exception) {
            getServletContext().log("Login failed.", exception);

            resp.sendRedirect(
                    req.getContextPath() + "/login.jsp?error=failed");
        }
    }
}
