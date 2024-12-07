<!DOCTYPE html>
<html>
<head>
    <title>New Account Screen</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        .createAccount {
            text-align: center;
            margin-top: 100px;
        }
        h2 {
            text-align: center;
        }
        h3 {
            font-size: 24px;
        }
        form {
            margin: 20px auto;
            display: inline-block;
            text-align: left;
        }
        table {
            margin: 0 auto;
        }
        td {
            padding: 8px;
        }
        .submit {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-align: center;
        }
        .submit:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="createAccount">
    <h2> ACCOUNT INFORMATION </h2>
    <%
    if (session.getAttribute("loginMessage") != null) {
        out.println("<p class='error-message'>" + session.getAttribute("loginMessage").toString() + "</p>");
    }
    %>

    <form name="MyForm" method="post" action="addUser.jsp">
        <table>
            <tr>
                <td><label for="firstName">First Name:</label></td>
                <td><input type="text" name="firstName" id="firstName" maxlength="40" placeholder="First name" pattern="[A-Za-z\s]+" title="Only letters and spaces allowed" required></td>
            </tr>
            <tr>
                <td><label for="lastName">Last Name:</label></td>
                <td><input type="text" name="lastName" id="lastName" maxlength="40" placeholder="Last name" pattern="[A-Za-z\s]+" title="Only letters and spaces allowed" required></td>
            </tr>
            <tr>
                <td><label for="email">Email:</label></td>
                <td><input type="email" name="email" id="email" maxlength="50" placeholder="example@domain.com" required></td>
            </tr>
            <tr>
                <td><label for="phoneNumber">Phone Number:</label></td>
                <td><input type="tel" name="phoneNumber" id="phoneNumber" maxlength="20" placeholder="123-456-7890" pattern="\d{3}-\d{3}-\d{4}" title="Format: 123-456-7890" required></td>
            </tr>
            <tr>
                <td><label for="address">Address:</label></td>
                <td><input type="text" name="address" id="address" maxlength="50" placeholder="123 Main St" required></td>
            </tr>
            <tr>
                <td><label for="city">City:</label></td>
                <td><input type="text" name="city" id="city" maxlength="40" placeholder="City name" pattern="[A-Za-z\s]+" title="Only letters and spaces allowed" required></td>
            </tr>
            <tr>
                <td><label for="state">State/Province:</label></td>
                <td><input type="text" name="state" id="state" maxlength="20" placeholder="State/Province" pattern="[A-Za-z\s]+" title="Only letters and spaces allowed" required></td>
            </tr>
            <tr>
                <td><label for="postalCode">Postal Code:</label></td>
                <td><input type="text" name="postalCode" id="postalCode" maxlength="20" placeholder="12345 or A1A 1A1" pattern="[A-Za-z0-9\s]+" title="Alphanumeric postal code" required></td>
            </tr>
            <tr>
                <td><label for="country">Country:</label></td>
                <td><input type="text" name="country" id="country" maxlength="40" placeholder="Country name" pattern="[A-Za-z\s]+" title="Only letters and spaces allowed" required></td>
            </tr>            
            <tr>
                <td><label for="username">Username:</label></td>
                <td><input type="text" name="username" id="username" size="15" maxlength="20" placeholder="Username" pattern="^\w{5,20}$" title="Username must be 5-20 characters, alphanumeric" required></td>
            </tr>
            <tr>
                <td><label for="password">Password:</label></td>
                <td><input type="password" name="password" id="password" size="15" maxlength="30" placeholder="Password" pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$" title="Password must be at least 8 characters, include at least one letter and one number" required></td>
            </tr>
        </table>
        <br/>
        <input class="submit" type="submit" name="Submit2" value="Create My Account!">
      
    </form>
</div>

</body>
</html>
