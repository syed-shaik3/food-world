
package com.tap.controller;

import java.io.IOException;
import java.sql.Timestamp;

import com.tap.daoimpl.OrderDaoImpl;
import com.tap.daoimpl.OrderItemDaoImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDaoImpl orderDao = new OrderDaoImpl();
    private final OrderItemDaoImpl orderItemDao = new OrderItemDaoImpl();

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        req.setAttribute("cart", cart);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        // Check session
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Get cart
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // Get logged-in user ID
        int userId = 0;
        Object userIdObject = session.getAttribute("userId");

        if (userIdObject instanceof Number) {
            userId = ((Number) userIdObject).intValue();
        } else {
            Object userObject = session.getAttribute("user");

            if (userObject instanceof User) {
                userId = ((User) userObject).getUserId();
            }
        }

        if (userId <= 0) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Read delivery form values
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");
        String landmark = req.getParameter("landmark");
        String paymentMethod = req.getParameter("paymentMethod");

        fullName = fullName == null ? "" : fullName.trim();
        phone = phone == null ? "" : phone.trim();
        address = address == null ? "" : address.trim();
        landmark = landmark == null ? "" : landmark.trim();

        // Validate name
        if (fullName.isEmpty()) {
            forwardWithError(req, resp, cart,
                    "Please enter your full name.");
            return;
        }

        // Validate phone number
        if (!phone.matches("[0-9]{10}")) {
            forwardWithError(req, resp, cart,
                    "Please enter a valid 10-digit phone number.");
            return;
        }

        // Validate address
        if (address.isEmpty()) {
            forwardWithError(req, resp, cart,
                    "Please enter your delivery address.");
            return;
        }

        // Validate payment method
        if (paymentMethod == null ||
                !(paymentMethod.equals("COD")
                || paymentMethod.equals("UPI")
                || paymentMethod.equals("CREDIT_CARD")
                || paymentMethod.equals("DEBIT_CARD"))) {

            forwardWithError(req, resp, cart,
                    "Please select a valid payment method.");
            return;
        }

        // Calculate total on the server
        double itemTotal = cart.getTotalAmount();
        double deliveryFee = itemTotal >= 499 ? 0 : 30;
        double totalAmount = itemTotal + deliveryFee;

        // Create Order object
        Order order = new Order();

        order.setUserId(userId);
        order.setRestaurantId(cart.getRestaurantId());
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setTotalAmount(totalAmount);
        order.setStatus("PLACED");
        order.setPaymentMode(paymentMethod);

        order.setDeliveryName(fullName);
        order.setDeliveryPhone(phone);
        order.setDeliveryAddress(address);
        order.setLandmark(landmark);

        try {
            // Save order and retrieve generated order ID
            int orderId = orderDao.addOrder(order);

            if (orderId <= 0) {
                forwardWithError(req, resp, cart,
                        "Unable to save your order. Please try again.");
                return;
            }

            // Save each cart item
            for (CartItem cartItem : cart.getItems()) {

                OrderItem orderItem = new OrderItem();

                orderItem.setOrderId(orderId);
                orderItem.setMenuId(cartItem.getMenu().getMenuId());
                orderItem.setQuantity(cartItem.getQuantity());
                orderItem.setItemTotal(cartItem.getSubtotal());

                orderItemDao.addOrderItem(orderItem);
            }

            // Store latest order ID in session
            session.setAttribute("lastOrderId", orderId);

            // Clear cart after successful inserts
            cart.clear();
            session.removeAttribute("cart");

            // Redirect to order history
         // Redirect to order success page
            resp.sendRedirect(req.getContextPath() + "/order-success.jsp");

        } catch (RuntimeException e) {
            e.printStackTrace();

            forwardWithError(req, resp, cart,
                    "An error occurred while saving your order. "
                    + "Please check your order records before retrying.");
        }
    }

    // Forward back to checkout with an error
    private void forwardWithError(HttpServletRequest req,
                                  HttpServletResponse resp,
                                  Cart cart,
                                  String message)
            throws ServletException, IOException {

        req.setAttribute("cart", cart);
        req.setAttribute("errorMessage", message);

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }
}
