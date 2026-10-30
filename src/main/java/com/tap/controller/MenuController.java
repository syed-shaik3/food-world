package com.tap.controller;

import java.io.IOException;
import java.util.List;

import com.tap.daoimpl.MenuDaoImpl;
import com.tap.model.Menu;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menu")
public class MenuController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // NEW: PREVENT THE BROWSER FROM CACHING THE MENU RESPONSE
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        MenuDaoImpl menuDao = new MenuDaoImpl();

        int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));

        List<Menu> menuList =
                menuDao.getMenuByRestaurantId(restaurantId);

        req.setAttribute("allMenu", menuList);

        RequestDispatcher rd =
                req.getRequestDispatcher("menu.jsp");

        rd.forward(req, resp);
    }
}
