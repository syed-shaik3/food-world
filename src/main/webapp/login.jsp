<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%
    String contextPath = request.getContextPath();
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Login | FoodWorld</title>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

:root {
    --orange: #f4512a;
    --orange-dark: #df3e1d;
    --cream: #fffaf5;
    --text: #34302e;
    --muted: #776c65;
}

html {
    min-height: 100%;
}

body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    font-family: "Segoe UI", Arial, sans-serif;
    color: var(--text);

    background-color: #fff4e8;
    background-image:
        linear-gradient(
            rgba(255, 249, 242, 0.20),
            rgba(255, 249, 242, 0.20)
        ),
        url("<%= contextPath %>/images/auth-background.png");
    background-size: cover;
    background-position: center;
    background-repeat: no-repeat;
    background-attachment: fixed;
}

/* Navigation */

.navbar {
    min-height: 78px;
    padding: 12px 6%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;

    background: rgba(255, 250, 245, 0.88);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);

    border-bottom: 1px solid rgba(255, 255, 255, 0.85);
    box-shadow: 0 5px 22px rgba(105, 67, 39, 0.10);

    position: relative;
    z-index: 2;
}

.logo {
    display: flex;
    align-items: center;
    gap: 11px;
    text-decoration: none;
    flex-shrink: 0;
}

.logo-img {
    width: 49px;
    height: 49px;
    object-fit: contain;
    border-radius: 10px;
}

.logo span {
    color: var(--orange);
    font-size: 25px;
    font-weight: 800;
    letter-spacing: -0.6px;
}

.nav-links {
    display: flex;
    align-items: center;
    gap: 10px;
}

.nav-links a {
    padding: 11px 16px;
    color: var(--text);
    text-decoration: none;
    font-size: 13px;
    font-weight: 700;
    border-radius: 11px;
    transition: 0.25s;
}

.nav-links a:hover {
    background: var(--orange);
    color: #fff;
    box-shadow: 0 5px 14px rgba(244, 81, 42, 0.22);
}

/* Login section */

.login-container {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 42px 18px;
}

/* Glass-style login card */

.login-card {
    width: 100%;
    max-width: 430px;
    padding: 38px;

    background: rgba(255, 250, 245, 0.92);
    border: 1px solid rgba(255, 255, 255, 0.95);
    border-radius: 25px;

    box-shadow:
        0 20px 60px rgba(91, 53, 29, 0.19),
        0 4px 15px rgba(91, 53, 29, 0.08);

    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);

    animation: appear 0.5s ease;
}

@keyframes appear {
    from {
        opacity: 0;
        transform: translateY(12px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.login-heading {
    text-align: center;
    margin-bottom: 28px;
}

.eyebrow {
    display: inline-block;
    padding: 7px 13px;
    margin-bottom: 13px;
    border-radius: 20px;
    background: #ffeadf;
    color: var(--orange-dark);
    font-size: 11px;
    font-weight: 800;
    letter-spacing: 1.5px;
    text-transform: uppercase;
}

.login-heading h1 {
    font-size: 29px;
    line-height: 1.3;
    margin-bottom: 10px;
    font-weight: 800;
}

.login-heading h1 span {
    color: var(--orange);
}

.login-heading p {
    color: var(--muted);
    font-size: 13px;
    line-height: 1.7;
}

/* Error messages */

.error-message {
    padding: 12px 14px;
    margin-bottom: 20px;
    border-radius: 11px;
    border: 1px solid #f2c7bf;
    background: #fff0ed;
    color: #a62929;
    text-align: center;
    font-size: 12px;
    line-height: 1.6;
}

/* Form fields */

.form-group {
    margin-bottom: 22px;
}

.form-group label {
    display: block;
    margin-bottom: 9px;
    color: var(--text);
    font-size: 13px;
    font-weight: 750;
}

.input-wrapper {
    position: relative;
}

.form-group input {
    width: 100%;
    height: 49px;
    padding: 0 14px;

    border: 1px solid #e8dcd1;
    border-radius: 11px;
    outline: none;

    background: rgba(255, 255, 255, 0.85);
    color: var(--text);
    font-family: inherit;
    font-size: 13px;

    transition: 0.25s;
}

.form-group input::placeholder {
    color: #a69a91;
}

.form-group input:focus {
    border-color: var(--orange);
    background: #fff;
    box-shadow: 0 0 0 3px rgba(244, 81, 42, 0.12);
}

.password-input {
    padding-right: 68px !important;
}

.toggle-password {
    position: absolute;
    top: 50%;
    right: 13px;
    transform: translateY(-50%);
    background: none;
    border: none;
    color: var(--orange-dark);
    font-family: inherit;
    font-size: 12px;
    font-weight: 750;
    cursor: pointer;
}

.toggle-password:hover {
    text-decoration: underline;
}

/* Login button */

.login-btn {
    width: 100%;
    min-height: 49px;
    padding: 13px;

    border: none;
    border-radius: 12px;
    background: linear-gradient(135deg, #fa6038, #e94523);
    color: #fff;

    font-family: inherit;
    font-size: 15px;
    font-weight: 800;
    cursor: pointer;

    box-shadow: 0 7px 16px rgba(233, 75, 44, 0.23);
    transition: 0.25s;
}

.login-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 21px rgba(233, 75, 44, 0.30);
}

.login-btn:active {
    transform: translateY(0);
}

/* Registration and back links */

.register-link {
    margin-top: 23px;
    text-align: center;
    color: var(--muted);
    font-size: 13px;
    line-height: 1.8;
}

.register-link a {
    color: var(--orange-dark);
    font-weight: 800;
    text-decoration: none;
}

.register-link a:hover {
    text-decoration: underline;
}

.back-link {
    display: block;
    width: fit-content;
    margin: 18px auto 0;
    color: var(--muted);
    font-size: 12px;
    font-weight: 650;
    text-decoration: none;
    transition: 0.2s;
}

.back-link:hover {
    color: var(--orange);
}

/* Footer */

footer {
    padding: 17px 12px;
    text-align: center;
    color: #64564d;
    background: rgba(255, 250, 245, 0.86);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    font-size: 11px;
}

/* Responsive */

@media (max-width: 600px) {
    body {
        background-attachment: scroll;
    }

    .navbar {
        min-height: 68px;
        padding: 10px 4%;
    }

    .logo {
        gap: 7px;
    }

    .logo-img {
        width: 39px;
        height: 39px;
    }

    .logo span {
        font-size: 20px;
    }

    .nav-links {
        gap: 3px;
    }

    .nav-links a {
        padding: 9px 10px;
        font-size: 11px;
    }

    .login-container {
        padding: 28px 14px;
    }

    .login-card {
        padding: 29px 23px;
        border-radius: 20px;
    }

    .login-heading h1 {
        font-size: 26px;
    }
}

@media (max-width: 370px) {
    .logo span {
        font-size: 17px;
    }

    .logo-img {
        width: 34px;
        height: 34px;
    }

    .nav-links a {
        padding: 8px;
        font-size: 10px;
    }

    .login-card {
        padding: 24px 17px;
    }
}

@media (prefers-reduced-motion: reduce) {
    *, *::before, *::after {
        animation: none !important;
        transition: none !important;
    }
}
</style>
</head>

<body>

<!-- Navigation -->
<nav class="navbar">

    <a class="logo" href="<%= contextPath %>/restaurant">
        <img
            src="<%= contextPath %>/images/FoodWorld_logo.jpg"
            alt="FoodWorld Logo"
            class="logo-img">
        <span>FoodWorld</span>
    </a>

    <div class="nav-links">
        <a href="<%= contextPath %>/restaurant">Restaurants</a>
        <a href="<%= contextPath %>/cart">My Cart</a>
    </div>

</nav>

<!-- Login form -->
<main class="login-container">

    <section class="login-card">

        <div class="login-heading">
            <div class="eyebrow">Welcome Back</div>

            <h1>Welcome to <span>FoodWorld</span></h1>

            <p>Login to continue your delicious journey.</p>
        </div>

        <% if ("invalid".equals(error)) { %>
            <div class="error-message" role="alert">
                Invalid email or password. Please try again.
            </div>
        <% } else if ("required".equals(error)) { %>
            <div class="error-message" role="alert">
                Please login to continue.
            </div>
        <% } else if ("failed".equals(error)) { %>
            <div class="error-message" role="alert">
                Unable to login right now. Please try again.
            </div>
        <% } %>

        <form action="<%= contextPath %>/login" method="post">

            <div class="form-group">
                <label for="email">Email Address</label>

                <input
                    type="email"
                    id="email"
                    name="email"
                    placeholder="Enter your email address"
                    autocomplete="email"
                    required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>

                <div class="input-wrapper">
                    <input
                        type="password"
                        id="password"
                        name="password"
                        class="password-input"
                        placeholder="Enter your password"
                        autocomplete="current-password"
                        required>

                    <button
                        type="button"
                        class="toggle-password"
                        onclick="togglePassword()">
                        Show
                    </button>
                </div>
            </div>

            <button type="submit" class="login-btn">
                Login
            </button>

        </form>

        <div class="register-link">
            Don't have an account?
            <a href="<%= contextPath %>/register.jsp">Create Account</a>
        </div>

        <a class="back-link"
           href="<%= contextPath %>/restaurant">
            &larr; Back to Restaurants
        </a>

    </section>

</main>

<footer>
    &copy; 2026 FoodWorld. All rights reserved.
</footer>

<script>
function togglePassword() {
    const password = document.getElementById("password");
    const button = document.querySelector(".toggle-password");

    if (password.type === "password") {
        password.type = "text";
        button.textContent = "Hide";
    } else {
        password.type = "password";
        button.textContent = "Show";
    }
}
</script>

</body>
</html>
