
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Restaurant" %>

<%
    String contextPath = request.getContextPath();

    List<Restaurant> restaurants =
        (List<Restaurant>) request.getAttribute("restaurants");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>FoodWorld | Restaurants</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --page-bg: #fffaf6;
            --card-bg: #ffffff;
            --primary: #f4512a;
            --primary-dark: #d9401d;
            --text-dark: #111827;
            --text-muted: #596579;
            --soft-border: #f1e7df;
            --shadow-light: #ffffff;
            --shadow-warm: rgba(120, 75, 45, 0.10);
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            font-family: Arial, Helvetica, sans-serif;
            background: var(--page-bg);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        a {
            -webkit-tap-highlight-color: transparent;
        }

        /* =========================
           NEUMORPHIC NAVBAR
        ========================= */

        .navbar {
            width: 94%;
            min-height: 78px;
            margin: 0 auto;
            padding: 10px 28px;

            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;

            background: rgba(255, 255, 255, 0.97);
            border-radius: 0 0 28px 28px;

            box-shadow:
                0 8px 25px rgba(80, 50, 30, 0.07),
                inset 0 -1px 0 rgba(255, 255, 255, 0.9);

            position: sticky;
            top: 0;
            z-index: 100;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            flex-shrink: 0;
        }

        .logo-image {
            width: 65px;
            height: 55px;
            object-fit: contain;
            display: block;
        }

        .app-name {
            font-size: 29px;
            font-weight: 800;
            color: var(--text-dark);
            white-space: nowrap;
            letter-spacing: -1px;
        }

        .app-name span {
            color: var(--primary);
        }

        .nav-actions {
            display: flex;
            align-items: center;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 12px;
        }

        .nav-button {
            display: inline-flex;
            justify-content: center;
            align-items: center;

            padding: 13px 20px;
            min-height: 48px;

            border-radius: 28px;
            border: 1px solid #f0eeec;

            background: #faf9f8;
            color: #171717;

            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            white-space: nowrap;

            box-shadow:
                4px 4px 10px rgba(0, 0, 0, 0.055),
                -4px -4px 10px #ffffff;

            transition:
                background 0.25s ease,
                color 0.25s ease,
                box-shadow 0.25s ease,
                transform 0.25s ease;
        }

        .nav-button:hover {
            background: #fff0e9;
            color: #e94727;
            border-color: #ffded1;
            transform: translateY(-2px);

            box-shadow:
                0 5px 14px rgba(233, 75, 44, 0.12),
                -3px -3px 8px #ffffff;
        }

        .restaurants-button {
            background: #fff0e9;
            color: #e94727;
            border-color: #ffded1;
        }

        .nav-button:active {
            transform: translateY(1px);
            box-shadow: inset 3px 3px 7px rgba(0, 0, 0, 0.06);
        }

        /* =========================
           HERO SECTION
        ========================= */

        .hero {
            width: 100%;
            min-height: 320px;
            padding: 38px 7%;

            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 35px;

            background:
                radial-gradient(
                    circle at 12% 25%,
                    rgba(255, 218, 193, 0.55),
                    transparent 35%
                ),
                linear-gradient(110deg, #fffaf5, #ffeadf);

            overflow: hidden;
        }

        .hero-content {
            flex: 1.05;
            min-width: 0;
            padding: 10px 0;
        }

        .hero h1 {
            max-width: 650px;
            font-size: clamp(32px, 4.1vw, 55px);
            font-weight: 800;
            letter-spacing: -1.8px;
            line-height: 1.18;
            margin-bottom: 17px;
        }

        .hero h1 span {
            color: var(--primary);
        }

        .hero p {
            max-width: 650px;
            color: var(--text-muted);
            font-size: clamp(15px, 1.5vw, 19px);
            line-height: 1.65;
        }

        .hero-image-container {
            flex: 0.95;
            width: 100%;
            max-width: 570px;
            height: 280px;
            min-width: 0;

            overflow: hidden;
            border-radius: 35px;

            background: #f5e1d4;

            box-shadow:
                10px 12px 28px rgba(150, 90, 50, 0.13),
                -7px -7px 20px rgba(255, 255, 255, 0.85);
        }

        .hero-image {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover;
            object-position: center;
        }

        /* =========================
           RESTAURANT SECTION
        ========================= */

        .container {
            width: 100%;
            max-width: 1500px;
            margin: 0 auto;
            padding: 30px 4.6% 45px;
            flex: 1;
        }

        .section-heading {
            margin-bottom: 22px;
            padding: 0 5px;
        }

        .section-heading h2 {
            font-size: clamp(25px, 2.6vw, 36px);
            font-weight: 800;
            letter-spacing: -0.8px;
            margin-bottom: 7px;
        }

        .section-heading p {
            color: var(--text-muted);
            font-size: 16px;
            line-height: 1.5;
        }

        /* Restaurant grid */

        .restaurant-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 20px;
            align-items: stretch;
        }

        /* Neumorphic restaurant card */

        .restaurant-card {
            min-width: 0;
            background: var(--card-bg);
            border-radius: 27px;
            padding: 8px;

            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.95);

            box-shadow:
                7px 8px 22px rgba(100, 70, 50, 0.07),
                -5px -5px 18px rgba(255, 255, 255, 0.95);

            transition:
                transform 0.25s ease,
                box-shadow 0.25s ease;
        }

        .restaurant-card:hover {
            transform: translateY(-4px);

            box-shadow:
                10px 13px 27px rgba(100, 70, 50, 0.12),
                -5px -5px 15px #ffffff;
        }

        /* Restaurant image */

        .image-container {
            position: relative;
            width: 100%;
            height: 215px;
            overflow: hidden;
            border-radius: 20px;
            background: #eee5de;
        }

        .restaurant-image {
            width: 100%;
            height: 100%;
            display: block;
            object-fit: cover;
            transition: transform 0.35s ease;
        }

        .restaurant-card:hover .restaurant-image {
            transform: scale(1.035);
        }

        /* Open / Closed badge */

        .status {
            position: absolute;
            top: 12px;
            left: 12px;
            padding: 8px 16px;
            border-radius: 25px;

            font-size: 13px;
            font-weight: 700;

            box-shadow: 2px 3px 9px rgba(0, 0, 0, 0.08);
        }

        .open {
            color: #08743b;
            background: #dcfce7;
        }

        .closed {
            color: #991b1b;
            background: #fee2e2;
        }

        /* Details below the image */

        .restaurant-details {
            padding: 14px 12px 8px;
        }

        .restaurant-title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 10px;
            margin-bottom: 7px;
        }

        .restaurant-name {
            min-width: 0;
            font-size: 19px;
            font-weight: 800;
            line-height: 1.4;
            overflow-wrap: anywhere;
        }

        .rating {
            flex-shrink: 0;
            display: inline-flex;
            align-items: center;
            gap: 5px;

            padding: 7px 11px;
            border-radius: 12px;

            background: #198754;
            color: #ffffff;

            font-size: 13px;
            font-weight: 700;

            box-shadow:
                3px 4px 8px rgba(25, 135, 84, 0.15);
        }

        .cuisine {
            color: var(--text-muted);
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 12px;
            overflow-wrap: anywhere;
        }

        .restaurant-info {
            display: flex;
            align-items: flex-start;
            gap: 9px;

            color: #596579;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 9px;
        }

        .info-icon {
            width: 18px;
            flex-shrink: 0;
            text-align: center;
        }

        .address {
            display: flex;
            align-items: flex-start;
            gap: 9px;

            color: #596579;
            font-size: 14px;
            line-height: 1.5;
            min-height: 21px;
            margin-bottom: 14px;
            overflow-wrap: anywhere;
        }

        /* View Menu button */

        .card-footer {
            display: flex;
            align-items: center;
            padding-top: 4px;
        }

        .menu-button {
            display: block;
            width: 100%;
            padding: 12px 16px;

            border: none;
            border-radius: 14px;

            background: linear-gradient(
                100deg,
                #f4512a,
                #ff4d2e
            );

            color: #ffffff;
            text-align: center;
            text-decoration: none;

            font-size: 15px;
            font-weight: 700;

            box-shadow:
                3px 4px 9px rgba(244, 81, 42, 0.18);

            transition:
                background 0.25s ease,
                transform 0.25s ease,
                box-shadow 0.25s ease;
        }

        .menu-button:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);

            box-shadow:
                4px 6px 12px rgba(244, 81, 42, 0.25);
        }

        .menu-button.disabled {
            background: #b7b7b7;
            cursor: not-allowed;
            pointer-events: none;
            box-shadow: none;
        }

        /* Empty state */

        .empty-state {
            grid-column: 1 / -1;
            background: #ffffff;
            padding: 45px 20px;
            border-radius: 24px;
            text-align: center;
            color: var(--text-muted);

            box-shadow:
                7px 7px 18px rgba(100, 70, 50, 0.07),
                -5px -5px 15px #ffffff;
        }

        .empty-state h3 {
            color: var(--text-dark);
            margin-bottom: 10px;
            font-size: 22px;
        }

        .empty-state p {
            line-height: 1.6;
        }

        /* =========================
           FOOTER
        ========================= */

        .footer {
            margin-top: auto;
            padding: 25px 5%;

            background: #fffaf6;
            color: #647084;

            text-align: center;
            font-size: 13px;

            border-top: 1px solid var(--soft-border);

            box-shadow:
                0 -5px 18px rgba(100, 70, 50, 0.04);
        }

        /* =========================
           TABLET
        ========================= */

        @media (max-width: 1050px) {
            .navbar {
                width: 96%;
                padding: 10px 20px;
            }

            .logo-image {
                width: 55px;
            }

            .app-name {
                font-size: 25px;
            }

            .nav-actions {
                gap: 8px;
            }

            .nav-button {
                padding: 11px 14px;
                font-size: 13px;
            }

            .hero {
                padding: 35px 5%;
                gap: 25px;
            }

            .hero-image-container {
                height: 245px;
            }

            .restaurant-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        /* =========================
           MOBILE
        ========================= */

        @media (max-width: 650px) {
            .navbar {
                width: 100%;
                border-radius: 0 0 20px 20px;
                padding: 12px 4%;
                flex-direction: column;
                gap: 12px;
            }

            .logo {
                justify-content: center;
            }

            .logo-image {
                width: 50px;
                height: 45px;
            }

            .app-name {
                font-size: 25px;
            }

            .nav-actions {
                width: 100%;
                justify-content: center;
                gap: 7px;
            }

            .nav-button {
                min-height: 40px;
                padding: 10px 12px;
                font-size: 12px;
            }

            .hero {
                flex-direction: column;
                align-items: stretch;
                padding: 30px 5%;
                gap: 22px;
            }

            .hero h1 {
                font-size: clamp(30px, 8vw, 40px);
                letter-spacing: -1px;
            }

            .hero p {
                font-size: 15px;
            }

            .hero-image-container {
                flex: auto;
                width: 100%;
                max-width: none;
                height: 220px;
                border-radius: 24px;
            }

            .container {
                padding: 25px 5% 35px;
            }

            .section-heading h2 {
                font-size: 26px;
            }

            .section-heading p {
                font-size: 14px;
            }

            .restaurant-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .image-container {
                height: 230px;
            }

            .restaurant-details {
                padding: 14px 12px 9px;
            }

            .restaurant-name {
                font-size: 18px;
            }
        }
    </style>
</head>

<body>

    <!-- =========================
         NAVIGATION BAR
    ========================== -->

    <header class="navbar">

        <a class="logo" href="<%= contextPath %>/restaurant">

            <img
                src="<%= contextPath %>/images/FoodWorld_logo.jpg"
                alt="FoodWorld Logo"
                class="logo-image">

            <span class="app-name">
                Food<span>World</span>
            </span>

        </a>

        <nav class="nav-actions">

            <a class="nav-button restaurants-button"
               href="<%= contextPath %>/restaurant">
                Restaurants
            </a>

            <a class="nav-button"
               href="<%= contextPath %>/cart">
                My Cart
            </a>

            <a class="nav-button"
               href="<%= contextPath %>/orders">
                My Orders
            </a>

            <% if (session.getAttribute("user") == null) { %>

                <a class="nav-button login-button"
                   href="<%= contextPath %>/login">
                    Login
                </a>

			<%
			} else {
			%>

			<a class="nav-button login-button"
				href="<%=contextPath%>/profile"> My Profile </a> <a
				class="nav-button" href="<%=contextPath%>/logout"> Logout </a>

			<%
			}
			%>

		</nav>

    </header>


    <!-- =========================
         HERO SECTION
         Text on the left
         Food banner on the right
    ========================== -->

    <section class="hero">

        <div class="hero-content">

            <h1>
                Discover delicious food in
                <span>Bengaluru</span>
            </h1>

            <p>
                Explore local restaurants, discover your favourite cuisines,
                and find something delicious for your next meal.
            </p>

        </div>

        <div class="hero-image-container">

            <img
                src="<%= contextPath %>/images/restaurant/food-banner.jpg"
                alt="Delicious food served fresh"
                class="hero-image"
                onerror="this.onerror=null;this.src='<%= contextPath %>/images/restaurant/default.jpg';">

        </div>

    </section>


    <!-- =========================
         RESTAURANT LISTING
    ========================== -->

    <main class="container">

        <div class="section-heading">

            <h2>Explore Restaurants</h2>

            <p>
                Choose a restaurant and discover its delicious menu.
            </p>

        </div>

        <div class="restaurant-grid">

            <%
                if (restaurants != null && !restaurants.isEmpty()) {

                    for (Restaurant restaurant : restaurants) {

                        String imagePath = restaurant.getImagePath();

                        if (imagePath == null || imagePath.trim().isEmpty()) {
                            imagePath = "images/restaurant/default.jpg";
                        }

                        if (imagePath.startsWith("/")) {
                            imagePath = imagePath.substring(1);
                        }

                        boolean restaurantIsActive = restaurant.isActive();

                        String statusClass =
                            restaurantIsActive ? "open" : "closed";

                        String statusText =
                            restaurantIsActive ? "Open" : "Closed";

                        String cuisineType = restaurant.getCuisineType();

                        if (cuisineType == null || cuisineType.trim().isEmpty()) {
                            cuisineType = "Various cuisines";
                        }

                        String address = restaurant.getAddress();

                        if (address == null || address.trim().isEmpty()) {
                            address = "Bengaluru";
                        }
            %>

                <article class="restaurant-card">

                    <!-- Restaurant image -->

                    <div class="image-container">

                        <img
                            class="restaurant-image"
                            src="<%= contextPath %>/<%= imagePath %>"
                            alt="<%= restaurant.getName() %>"
                            loading="lazy"
                            onerror="this.onerror=null;this.src='<%= contextPath %>/images/restaurant/default.jpg';">

                        <span class="status <%= statusClass %>">
                            <%= statusText %>
                        </span>

                    </div>


                    <!-- Restaurant details below the image -->

                    <div class="restaurant-details">

                        <div class="restaurant-title-row">

                            <h3 class="restaurant-name">
                                <%= restaurant.getName() %>
                            </h3>

                            <span class="rating">
                                &#9733;
                                <%= String.format("%.1f", restaurant.getRating()) %>
                            </span>

                        </div>

                        <p class="cuisine">
                            <%= cuisineType %>
                        </p>

                        <div class="restaurant-info">

                            <span class="info-icon">&#128336;</span>

                            <span>
                                <%= restaurant.getDeliveryTime() %>
                                minutes delivery
                            </span>

                        </div>

                        <p class="address">

                            <span class="info-icon">&#128205;</span>

                            <span>
                                <%= address %>
                            </span>

                        </p>

                        <div class="card-footer">

                            <% if (restaurantIsActive) { %>

                                <a
                                    class="menu-button"
                                    href="<%= contextPath %>/menu?restaurantId=<%= restaurant.getRestaurantId() %>">
                                    View Menu &#8250;
                                </a>

                            <% } else { %>

                                <span class="menu-button disabled">
                                    Currently Closed
                                </span>

                            <% } %>

                        </div>

                    </div>

                </article>

            <%
                    }

                } else {
            %>

                <div class="empty-state">

                    <h3>No restaurants available</h3>

                    <p>
                        Please check your restaurant records and try again.
                    </p>

                </div>

            <%
                }
            %>

        </div>

    </main>


    <!-- =========================
         FOOTER
    ========================== -->

    <footer class="footer">

        <p>
            &copy; <%= java.time.Year.now() %> FoodWorld.
            All rights reserved.
        </p>

    </footer>

</body>
</html>
