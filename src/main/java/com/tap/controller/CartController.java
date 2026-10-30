package com.tap.controller;

import java.io.IOException;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Cart;
import com.tap.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String action = req.getParameter("action");

        // NEW: READS THE PAGE THAT SENT THE REQUEST
        String source = req.getParameter("source");

        // NEW: READS THE RESTAURANT ID SENT FROM MENU.JSP
        String restaurantIdParameter = req.getParameter("restaurantId");

        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
            return;
        }

        if ("add".equals(action)) {

            String menuIdParameter = req.getParameter("menuId");

            if (menuIdParameter == null || menuIdParameter.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/restaurant");
                return;
            }

            int menuId;

            try {
                menuId = Integer.parseInt(menuIdParameter);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/restaurant");
                return;
            }

            if (menuId <= 0) {
                resp.sendRedirect(req.getContextPath() + "/restaurant");
                return;
            }

            MenuDaoImpl menuDao = new MenuDaoImpl();
            Menu menu = menuDao.getMenu(menuId);

            if (menu == null || !menu.isIs_available()) {
                resp.sendRedirect(req.getContextPath() + "/restaurant");
                return;
            }

            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null) {
                cart = new Cart();
            }

            boolean added = cart.addItem(menu);

            if (added) {
                session.setAttribute("cart", cart);

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + menu.getRestaurantId()
                );

            } else {
                session.setAttribute(
                    "cartError",
                    "You can add items from only one restaurant at a time."
                );

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + menu.getRestaurantId()
                    + "&cartError=1"
                );
            }

        } else if ("update".equals(action)) {

            String menuIdParameter = req.getParameter("menuId");
            String quantityParameter = req.getParameter("quantity");

            if (menuIdParameter == null || quantityParameter == null
                    || menuIdParameter.trim().isEmpty()
                    || quantityParameter.trim().isEmpty()) {

                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            int menuId;
            int quantity;

            try {
                menuId = Integer.parseInt(menuIdParameter);
                quantity = Integer.parseInt(quantityParameter);
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            if (menuId <= 0 || quantity < 0) {
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            Cart cart = (Cart) session.getAttribute("cart");

            if (cart == null || cart.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/cart");
                return;
            }

            // NEW: SAVE THE RESTAURANT ID BEFORE UPDATING THE QUANTITY.
            // THIS ALSO WORKS WHEN THE LAST ITEM IS REMOVED.
            int currentRestaurantId = cart.getRestaurantId();

            cart.updateQuantity(menuId, quantity);

            if (cart.isEmpty()) {
                session.removeAttribute("cart");
            } else {
                session.setAttribute("cart", cart);
            }

            // NEW: REDIRECT TO THE PAGE THAT SENT THE UPDATE REQUEST.
            if ("menu".equals(source)) {

                // NEW: USE THE RESTAURANT ID SENT FROM MENU.JSP.
                int restaurantId = currentRestaurantId;

                // NEW: USE THE REQUEST PARAMETER WHEN IT IS VALID.
                if (restaurantIdParameter != null
                        && !restaurantIdParameter.trim().isEmpty()) {
                    try {
                        restaurantId = Integer.parseInt(restaurantIdParameter);
                    } catch (NumberFormatException e) {
                        restaurantId = currentRestaurantId;
                    }
                }

                resp.sendRedirect(
                    req.getContextPath()
                    + "/menu?restaurantId="
                    + restaurantId
                );

            } else {
                // NEW: CART-PAGE UPDATES RETURN TO CART.JSP.
                resp.sendRedirect(req.getContextPath() + "/cart");
            }

        } else {
            resp.sendRedirect(req.getContextPath() + "/restaurant");
        }
    }
    
 // NEW: HANDLES GET REQUESTS WHEN THE USER CLICKS THE CART LINK
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.sendRedirect(req.getContextPath() + "/cart.jsp");
    }
}
