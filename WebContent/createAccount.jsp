<!DOCTYPE html>
<html>
<head>
    <title>Create Your Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .account-container {
            width: 90%;
            max-width: 700px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
        }
        h2 {
            text-align: center;
            color: #333333;
            font-size: 28px;
            margin-bottom: 20px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            font-size: 16px;
            color: #444444;
            margin-bottom: 8px;
            font-weight: bold;
        }
        input {
            font-size: 14px;
            padding: 10px;
            margin-bottom: 20px;
            border: 1px solid #cccccc;
            border-radius: 5px;
            width: 100%;
            box-sizing: border-box;
        }
        input:focus {
            border-color: #007bff;
            outline: none;
        }
        .submit {
            background-color: #007bff;
            color: white;
            font-size: 16px;
            font-weight: bold;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .submit:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            font-size: 14px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="account-container">
    <h2>Create Your Account</h2>
    <% if (session.getAttribute("loginMessage") != null) { %>
        <p class="error-message"><%= session.getAttribute("loginMessage").toString() %></p>
    <% } %>
    
    <form name="MyForm" method="post" action="// TODO LIAM">
        <label for="firstName">First Name:</label>
        <input type="text" name="firstName" id="firstName" maxlength="40" placeholder="Enter your first name" required>

        <label for="lastName">Last Name:</label>
        <input type="text" name="lastName" id="lastName" maxlength="40" placeholder="Enter your last name" required>

        <label for="email">Email:</label>
        <input type="email" name="email" id="email" maxlength="50" placeholder="Enter your email" required>

        <label for="phoneNumber">Phone Number:</label>
        <input type="tel" name="phoneNumber" id="phoneNumber" maxlength="20" placeholder="Enter your phone number" required>

        <label for="address">Address:</label>
        <input type="text" name="address" id="address" maxlength="50" placeholder="Enter your address" required>

        <label for="city">City:</label>
        <input type="text" name="city" id="city" maxlength="40" placeholder="Enter your city" required>

        <label for="state">State/Province:</label>
        <input type="text" name="state" id="state" maxlength="20" placeholder="Enter your state/province" required>

        <label for="postalCode">Postal Code:</label>
        <input type="text" name="postalCode" id="postalCode" maxlength="20" placeholder="Enter your postal code" required>

        <label for="country">Country:</label>
        <input type="text" name="country" id="country" maxlength="40" placeholder="Enter your country" required>

        <label for="username">Username:</label>
        <input type="text" name="username" id="username" maxlength="20" placeholder="Choose a username" required>

        <label for="password">Password:</label>
        <input type="password" name="password" id="password" maxlength="30" placeholder="Create a password" required>

        <button class="submit" type="submit">Create My Account!</button>
    </form>
</div>

</body>
</html>
