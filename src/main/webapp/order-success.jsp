
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    Integer userId = (Integer) session.getAttribute("userId");
    Integer orderId = (Integer) session.getAttribute("lastOrderId");

    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (orderId == null) {
        response.sendRedirect(request.getContextPath() + "/orders");
        return;
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Order Successful | FoodWorld</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Arial, sans-serif;
    background: #fffaf4;
    color: #333;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

/* NAVBAR */

.navbar {
    width: 100%;
    height: 75px;
    background: #ffffff;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 7%;
    box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}

.logo {
    display: flex;
    align-items: center;
    gap: 10px;
    text-decoration: none;
}

.logo img {
    width: 48px;
    height: 48px;
    object-fit: contain;
}

.logo span {
    font-size: 25px;
    font-weight: 800;
    color: #f4512a;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 25px;
}

.nav-links a {
    text-decoration: none;
    color: #444;
    font-size: 14px;
    font-weight: 600;
    transition: 0.3s;
}

.nav-links a:hover {
    color: #f4512a;
}

/* MAIN CONTENT */

.main-container {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 55px 20px;
}

.success-card {
    background: #ffffff;
    width: 100%;
    max-width: 560px;
    padding: 48px 35px;
    border-radius: 22px;
    text-align: center;
    box-shadow: 0 12px 40px rgba(0,0,0,0.07);
    animation: cardAppear 0.7s ease both;
}

@keyframes cardAppear {
    from {
        opacity: 0;
        transform: translateY(25px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* SUCCESS TICK */

.success-animation {
    width: 120px;
    height: 120px;
    margin: 0 auto 28px;
    position: relative;
}

.success-circle {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background: #20b66b;
    display: flex;
    justify-content: center;
    align-items: center;
    transform: scale(0);
    animation: circlePop 0.55s cubic-bezier(.18,.89,.32,1.28) 0.2s forwards;
    box-shadow: 0 8px 25px rgba(32,182,107,0.25);
}

.success-circle svg {
    width: 65px;
    height: 65px;
}

.success-circle path {
    fill: none;
    stroke: #ffffff;
    stroke-width: 7;
    stroke-linecap: round;
    stroke-linejoin: round;
    stroke-dasharray: 100;
    stroke-dashoffset: 100;
    animation: drawTick 0.55s ease 0.75s forwards;
}

@keyframes circlePop {
    0% {
        transform: scale(0);
    }
    75% {
        transform: scale(1.15);
    }
    100% {
        transform: scale(1);
    }
}

@keyframes drawTick {
    to {
        stroke-dashoffset: 0;
    }
}

/* CONFETTI */

.confetti-container {
    position: fixed;
    inset: 0;
    pointer-events: none;
    overflow: hidden;
    z-index: 10;
}

.confetti {
    position: absolute;
    top: -20px;
    width: 9px;
    height: 14px;
    opacity: 0;
    animation: confettiFall 2.8s ease-out forwards;
}

@keyframes confettiFall {
    0% {
        opacity: 1;
        transform: translateY(0) rotate(0deg);
    }
    100% {
        opacity: 0;
        transform: translateY(100vh) rotate(720deg);
    }
}

/* SUCCESS TEXT */

.success-title {
    color: #222;
    font-size: 29px;
    font-weight: 800;
    margin-bottom: 12px;
    animation: fadeUp 0.7s ease 0.9s both;
}

.success-description {
    color: #777;
    font-size: 15px;
    line-height: 1.7;
    margin-bottom: 25px;
    animation: fadeUp 0.7s ease 1s both;
}

@keyframes fadeUp {
    from {
        opacity: 0;
        transform: translateY(12px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* ORDER ID */

.order-id-box {
    background: #fff6ed;
    border: 1px dashed #f4512a;
    padding: 17px;
    border-radius: 12px;
    margin: 25px 0;
    animation: fadeUp 0.7s ease 1.1s both;
}

.order-id-label {
    font-size: 12px;
    color: #888;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 7px;
}

.order-id {
    font-size: 23px;
    color: #f4512a;
    font-weight: 800;
}

/* EXTRA MESSAGE */

.thank-you {
    font-size: 14px;
    color: #777;
    margin: 20px 0 28px;
    animation: fadeUp 0.7s ease 1.2s both;
}

/* BUTTONS */

.button-container {
    display: flex;
    flex-direction: column;
    gap: 13px;
    animation: fadeUp 0.7s ease 1.3s both;
}

.btn {
    width: 100%;
    padding: 15px 20px;
    border-radius: 10px;
    text-decoration: none;
    font-size: 15px;
    font-weight: 700;
    transition: all 0.3s ease;
    display: block;
}

.primary-btn {
    background: #f4512a;
    color: white;
    border: 2px solid #f4512a;
}

.primary-btn:hover {
    background: #dc3e1b;
    border-color: #dc3e1b;
    transform: translateY(-2px);
    box-shadow: 0 6px 15px rgba(244,81,42,0.2);
}

.secondary-btn {
    background: white;
    color: #f4512a;
    border: 2px solid #f4512a;
}

.secondary-btn:hover {
    background: #fff3ed;
    transform: translateY(-2px);
}

/* FOOTER */

.footer {
    background: #ffffff;
    text-align: center;
    padding: 20px;
    color: #888;
    font-size: 13px;
    border-top: 1px solid #f0ece8;
}

/* RESPONSIVE */

@media (max-width: 600px) {

    .navbar {
        height: 65px;
        padding: 0 18px;
    }

    .logo span {
        font-size: 21px;
    }

    .logo img {
        width: 40px;
        height: 40px;
    }

    .nav-links {
        gap: 12px;
    }

    .nav-links a {
        font-size: 12px;
    }

    .success-card {
        padding: 38px 20px;
    }

    .success-title {
        font-size: 24px;
    }

    .success-animation,
    .success-circle {
        width: 105px;
        height: 105px;
    }

    .success-circle svg {
        width: 58px;
        height: 58px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation-duration: 0.01ms !important;
        animation-iteration-count: 1 !important;
        scroll-behavior: auto !important;
    }
}
</style>
</head>

<body>

<!-- CONFETTI CONTAINER -->
<div class="confetti-container" id="confettiContainer"></div>

<!-- NAVBAR -->
<header class="navbar">

    <a href="<%= contextPath %>/restaurant" class="logo">
        <img src="<%= contextPath %>/images/FoodWorld_logo.jpg"
             alt="FoodWorld Logo">
        <span>FoodWorld</span>
    </a>

    <nav class="nav-links">
        <a href="<%= contextPath %>/restaurant">Restaurants</a>
        <a href="<%= contextPath %>/orders">My Orders</a>
    </nav>

</header>

<!-- MAIN CONTENT -->
<main class="main-container">

    <section class="success-card">

        <!-- ANIMATED GREEN TICK -->
        <div class="success-animation">

            <div class="success-circle">

                <svg viewBox="0 0 60 60">
                    <path d="M12 31 L25 43 L49 17"/>
                </svg>

            </div>

        </div>

        <!-- SUCCESS MESSAGE -->
        <h1 class="success-title">
            Order Placed Successfully!
        </h1>

        <p class="success-description">
            Hurray! Your order has been confirmed.
            Get ready to enjoy delicious food!
        </p>

        <!-- ORDER ID -->
        <div class="order-id-box">

            <p class="order-id-label">
                Your Order ID
            </p>

            <p class="order-id">
                #<%= orderId %>
            </p>

        </div>

        <p class="thank-you">
            Thank you for choosing FoodWorld.
            We appreciate your order!
        </p>

        <!-- NAVIGATION BUTTONS -->
        <div class="button-container">

            <a href="<%= contextPath %>/orders"
               class="btn primary-btn">
                View My Orders
            </a>

            <a href="<%= contextPath %>/restaurant"
               class="btn secondary-btn">
                Continue Shopping
            </a>

        </div>

    </section>

</main>

<!-- FOOTER -->
<footer class="footer">
    <p>© 2026 FoodWorld. Made with ❤️ for food lovers.</p>
</footer>

<!-- CONFETTI ANIMATION -->
<script>

(function () {

    const container = document.getElementById("confettiContainer");

    const colors = [
        "#f4512a",
        "#ffbd59",
        "#20b66b",
        "#ff6b81",
        "#4da6ff",
        "#ffd700"
    ];

    const numberOfConfetti = 90;

    for (let i = 0; i < numberOfConfetti; i++) {

        const piece = document.createElement("span");

        piece.classList.add("confetti");

        piece.style.left = Math.random() * 100 + "%";

        piece.style.backgroundColor =
            colors[Math.floor(Math.random() * colors.length)];

        piece.style.animationDelay = Math.random() * 0.8 + "s";

        piece.style.animationDuration =
            (2 + Math.random() * 1.5) + "s";

        piece.style.width = (6 + Math.random() * 7) + "px";

        piece.style.height = (9 + Math.random() * 9) + "px";

        container.appendChild(piece);
    }

    // Remove confetti after animation
    setTimeout(function () {
        container.innerHTML = "";
    }, 4500);

})();

</script>

</body>
</html>
