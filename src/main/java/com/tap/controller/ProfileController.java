
package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.UserDaoImpl;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDaoImpl userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    // Display the user's profile
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int userId = (Integer) session.getAttribute("userId");

            User user = userDao.getUser(userId);

            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            request.setAttribute("profileUser", user);

            request.getRequestDispatcher("/profile.jsp")
                   .forward(request, response);

        } catch (RuntimeException exception) {
            getServletContext().log("Error loading user profile.", exception);

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load profile."
            );
        }
    }

    // Update the user's profile
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String username = request.getParameter("username");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (username == null || username.trim().isEmpty()
                || phone == null
                || !phone.trim().matches("[0-9]{10}")
                || address == null || address.trim().isEmpty()) {

            request.setAttribute("errorMessage",
                "Enter a username, valid 10-digit phone number, and address.");

            doGet(request, response);
            return;
        }

        try {
            // Retrieve existing user to preserve email, password, and role.
            User user = userDao.getUser(userId);

            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            user.setUsername(username.trim());
            user.setPhone(phone.trim());
            user.setAddress(address.trim());

            userDao.updateUser(user);

            // Refresh the session user with updated database details.
            User updatedUser = userDao.getUser(userId);
            session.setAttribute("user", updatedUser);

            response.sendRedirect(
                request.getContextPath() + "/profile?updated=true"
            );

        } catch (RuntimeException exception) {
            getServletContext().log("Error updating user profile.", exception);

            request.setAttribute("errorMessage",
                "Unable to update your profile. Please try again.");

            doGet(request, response);
        }
    }
}
