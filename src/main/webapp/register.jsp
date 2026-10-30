<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String contextPath = request.getContextPath();
    String errorMessage = (String) request.getAttribute("errorMessage");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Create Account | FoodWorld</title>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    :root {
        --orange: #f4512a;
        --orange-dark: #df3e1b;
        --cream: #fffaf5;
        --text: #302b28;
        --muted: #77716c;
        --border: #e8ddd4;
    }

    body {
        min-height: 100vh;
        font-family: Arial, Helvetica, sans-serif;
        color: var(--text);
        background-color: #f8f3ef;
        background-image:
            linear-gradient(
                rgba(255, 250, 245, 0.42),
                rgba(255, 250, 245, 0.42)
            ),
            url("<%= contextPath %>/images/auth-background.png");
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        display: flex;
        flex-direction: column;
    }

    /* Navigation bar */

    .navbar {
        width: 100%;
        min-height: 76px;
        padding: 12px 6%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
        background: rgba(255, 250, 245, 0.95);
        border-bottom: 1px solid rgba(232, 221, 212, 0.8);
        box-shadow: 0 3px 15px rgba(60, 35, 20, 0.06);
    }

    .brand {
        display: flex;
        align-items: center;
        gap: 11px;
        text-decoration: none;
        color: var(--text);
        font-size: 25px;
        font-weight: 800;
        letter-spacing: -0.7px;
    }

    .brand img {
        width: 48px;
        height: 48px;
        object-fit: contain;
        border-radius: 10px;
    }

    .brand span {
        color: var(--orange);
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 22px;
    }

    .nav-links a {
        text-decoration: none;
        color: #403934;
        font-size: 14px;
        font-weight: 600;
        transition: color 0.2s ease;
    }

    .nav-links a:hover {
        color: var(--orange);
    }

    .nav-links .login-link {
        padding: 10px 19px;
        border: 1px solid var(--orange);
        border-radius: 8px;
        color: var(--orange);
    }

    .nav-links .login-link:hover {
        color: white;
        background: var(--orange);
    }

    /* Main content */

    .main-content {
        flex: 1;
        display: flex;
        justify-content: center;
        align-items: center;
        padding: 38px 18px;
    }

    .register-card {
        width: 100%;
        max-width: 510px;
        padding: 32px 38px;
        border: 1px solid rgba(255, 255, 255, 0.8);
        border-radius: 20px;
        background: rgba(255, 250, 245, 0.95);
        box-shadow: 0 18px 55px rgba(75, 43, 24, 0.16);
        backdrop-filter: blur(12px);
    }

    .heading {
        text-align: center;
        margin-bottom: 24px;
    }

    .heading h1 {
        font-size: 29px;
        margin-bottom: 9px;
        letter-spacing: -0.8px;
    }

    .heading h1 span {
        color: var(--orange);
    }

    .heading p {
        color: var(--muted);
        font-size: 14px;
        line-height: 1.6;
    }

    /* Messages */

    .message {
        padding: 12px 14px;
        margin-bottom: 18px;
        border-radius: 8px;
        font-size: 13px;
        line-height: 1.5;
        overflow-wrap: anywhere;
    }

    .error-message {
        color: #a32620;
        background: #fff0ee;
        border: 1px solid #f2c3be;
    }

    .success-message {
        color: #236b39;
        background: #edf9ef;
        border: 1px solid #b9e4c1;
    }

    /* Form fields */

    .form-group {
        margin-bottom: 16px;
    }

    .form-group label {
        display: block;
        margin-bottom: 7px;
        color: #38312c;
        font-size: 13px;
        font-weight: 700;
    }

    .form-group input {
        display: block;
        width: 100%;
        height: 45px;
        padding: 0 13px;
        border: 1px solid var(--border);
        border-radius: 9px;
        outline: none;
        background: rgba(255, 255, 255, 0.95);
        color: var(--text);
        font-family: inherit;
        font-size: 14px;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    .form-group input:focus {
        border-color: var(--orange);
        box-shadow: 0 0 0 3px rgba(244, 81, 42, 0.11);
    }

    .form-group input::placeholder {
        color: #aaa19a;
    }

    .password-wrapper {
        position: relative;
    }

    .password-wrapper input {
        padding-right: 70px;
    }

    .toggle-password {
        position: absolute;
        top: 50%;
        right: 12px;
        transform: translateY(-50%);
        padding: 5px 0;
        border: none;
        background: transparent;
        color: var(--orange);
        font-size: 12px;
        font-weight: 700;
        cursor: pointer;
    }

    .password-hint {
        display: block;
        margin-top: 6px;
        color: var(--muted);
        font-size: 11px;
    }

    /* Terms and conditions */

    .terms-row {
        display: flex;
        align-items: flex-start;
        gap: 9px;
        margin: 5px 0 20px;
        color: #625a54;
        font-size: 12px;
        line-height: 1.6;
    }

    .terms-row input {
        flex-shrink: 0;
        width: 15px;
        height: 15px;
        margin-top: 2px;
        accent-color: var(--orange);
        cursor: pointer;
    }

    .terms-row label {
        cursor: pointer;
    }

    .terms-row a {
        color: var(--orange);
        text-decoration: none;
        font-weight: 700;
    }

    /* Submit button */

    .register-button {
        width: 100%;
        min-height: 47px;
        border: none;
        border-radius: 9px;
        background: var(--orange);
        color: white;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        box-shadow: 0 6px 15px rgba(244, 81, 42, 0.2);
        transition: background 0.2s, transform 0.2s;
    }

    .register-button:hover {
        background: var(--orange-dark);
        transform: translateY(-1px);
    }

    .login-text {
        margin-top: 21px;
        text-align: center;
        color: var(--muted);
        font-size: 13px;
        line-height: 1.7;
    }

    .login-text a {
        color: var(--orange);
        text-decoration: none;
        font-weight: 700;
    }

    .login-text a:hover {
        text-decoration: underline;
    }

    /* Footer */

    .footer {
        padding: 18px 15px;
        text-align: center;
        background: rgba(255, 250, 245, 0.95);
        border-top: 1px solid rgba(232, 221, 212, 0.8);
        color: #80766e;
        font-size: 12px;
    }

    @media (max-width: 600px) {
        .navbar {
            padding: 12px 18px;
            min-height: 68px;
        }

        .brand {
            font-size: 21px;
            gap: 7px;
        }

        .brand img {
            width: 40px;
            height: 40px;
        }

        .nav-links {
            gap: 12px;
        }

        .nav-links a {
            font-size: 12px;
        }

        .nav-links .login-link {
            padding: 9px 12px;
        }

        .main-content {
            padding: 25px 13px;
        }

        .register-card {
            padding: 26px 22px;
            border-radius: 16px;
        }

        .heading h1 {
            font-size: 26px;
        }
    }

    @media (max-width: 380px) {
        .brand {
            font-size: 18px;
        }

        .brand img {
            width: 34px;
            height: 34px;
        }

        .nav-links {
            gap: 8px;
        }
    }
</style>
</head>

<body>

    <!-- Navigation -->
    <header class="navbar">

        <a class="brand" href="<%= contextPath %>/restaurant">
            <img
                src="<%= contextPath %>/images/FoodWorld_logo.jpg"
                alt="FoodWorld Logo">
            <div>Food<span>World</span></div>
        </a>

        <nav class="nav-links">
            <a href="<%= contextPath %>/restaurant">Restaurants</a>
            <a class="login-link" href="<%= contextPath %>/login">Login</a>
        </nav>

    </header>

    <!-- Registration section -->
    <main class="main-content">

        <section class="register-card">

            <div class="heading">
                <h1>Create Your <span>Account</span></h1>
                <p>Join FoodWorld and enjoy your favourite food.</p>
            </div>

            <!-- Error returned through RequestDispatcher -->
            <% if (errorMessage != null) { %>
                <div class="message error-message" role="alert">
                    <%= errorMessage %>
                </div>
            <% } %>

            <!-- Optional query-parameter error messages -->
            <% if ("exists".equals(error)) { %>
                <div class="message error-message" role="alert">
                    This email is already registered. Please log in.
                </div>
            <% } else if ("invalid".equals(error)) { %>
                <div class="message error-message" role="alert">
                    Please check your details and try again.
                </div>
            <% } else if ("password".equals(error)) { %>
                <div class="message error-message" role="alert">
                    Passwords do not match.
                </div>
            <% } else if ("failed".equals(error)) { %>
                <div class="message error-message" role="alert">
                    Registration failed. Please try again.
                </div>
            <% } %>

            <% if ("true".equals(success)) { %>
                <div class="message success-message" role="status">
                    Registration successful! You can now log in.
                </div>
            <% } %>

            <form
                action="<%= contextPath %>/register"
                method="post"
                accept-charset="UTF-8"
                onsubmit="return validateRegistration();">

                <div class="form-group">
                    <label for="username">Full Name</label>
                    <input
                        type="text"
                        id="username"
                        name="username"
                        placeholder="Enter your full name"
                        maxlength="100"
                        autocomplete="name"
                        required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input
                        type="email"
                        id="email"
                        name="email"
                        placeholder="Enter your email address"
                        maxlength="150"
                        autocomplete="email"
                        required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input
                        type="tel"
                        id="phone"
                        name="phone"
                        placeholder="Enter your 10-digit phone number"
                        inputmode="numeric"
                        pattern="[0-9]{10}"
                        maxlength="10"
                        minlength="10"
                        autocomplete="tel"
                        required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>

                    <div class="password-wrapper">
                        <input
                            type="password"
                            id="password"
                            name="password"
                            placeholder="Create a password"
                            minlength="8"
                            maxlength="72"
                            autocomplete="new-password"
                            required>

                        <button
                            type="button"
                            class="toggle-password"
                            onclick="togglePassword('password', this)">
                            Show
                        </button>
                    </div>

                    <small class="password-hint">
                        Use at least 8 characters.
                    </small>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password</label>

                    <div class="password-wrapper">
                        <input
                            type="password"
                            id="confirmPassword"
                            name="confirmPassword"
                            placeholder="Enter your password again"
                            minlength="8"
                            maxlength="72"
                            autocomplete="new-password"
                            required>

                        <button
                            type="button"
                            class="toggle-password"
                            onclick="togglePassword('confirmPassword', this)">
                            Show
                        </button>
                    </div>
                </div>

                <div class="terms-row">
                    <input
                        type="checkbox"
                        id="terms"
                        name="terms"
                        value="accepted"
                        required>

                    <label for="terms">
                        I confirm that the information provided is correct
                        and agree to the site's applicable terms.
                    </label>
                </div>

                <button type="submit" class="register-button">
                    Create Account
                </button>

            </form>

            <p class="login-text">
                Already have an account?
                <a href="<%= contextPath %>/login">Login here</a>
            </p>

        </section>

    </main>

    <!-- Footer -->
    <footer class="footer">
        &copy; 2026 FoodWorld. All rights reserved.
    </footer>

    <script>
        function togglePassword(inputId, button) {
            const input = document.getElementById(inputId);

            if (input.type === "password") {
                input.type = "text";
                button.textContent = "Hide";
            } else {
                input.type = "password";
                button.textContent = "Show";
            }
        }

        function validateRegistration() {
            const username =
                document.getElementById("username").value.trim();

            const email =
                document.getElementById("email").value.trim();

            const phone =
                document.getElementById("phone").value.trim();

            const password =
                document.getElementById("password").value;

            const confirmPassword =
                document.getElementById("confirmPassword").value;

            const terms =
                document.getElementById("terms").checked;

            if (username.length === 0) {
                alert("Please enter your full name.");
                return false;
            }

            if (email.length === 0) {
                alert("Please enter your email address.");
                return false;
            }

            if (!/^[0-9]{10}$/.test(phone)) {
                alert("Please enter a valid 10-digit phone number.");
                return false;
            }

            if (password.length < 8 || password.length > 72) {
                alert("Password must contain 8 to 72 characters.");
                return false;
            }

            if (password !== confirmPassword) {
                alert("Passwords do not match.");
                return false;
            }

            if (!terms) {
                alert("Please accept the terms to continue.");
                return false;
            }

            return true;
        }
    </script>

</body>
</html>
