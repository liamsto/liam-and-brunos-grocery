<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.Pattern" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        h1, p {
            text-align: center;
        }
        a {
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            padding: 10px 20px;
            border-radius: 5px;
            transition: background-color 0.3s;
            display: inline-block;
            margin-top: 20px;
        }
        a:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<%
    // Retrieve form data
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String phoneNumber = request.getParameter("phoneNumber");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalCode");
    String country = request.getParameter("country");
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    boolean valid = true;

    // Perform server-side validation
    if (firstName == null || firstName.isEmpty() || !Pattern.matches("[A-Za-z\\s]+", firstName)) valid = false;
    if (lastName == null || lastName.isEmpty() || !Pattern.matches("[A-Za-z\\s]+", lastName)) valid = false;
    if (email == null || email.isEmpty() || !email.contains("@")) valid = false;
    if (phoneNumber == null || phoneNumber.isEmpty() || !Pattern.matches("\\d{3}-\\d{3}-\\d{4}", phoneNumber)) valid = false;
    if (address == null || address.isEmpty()) valid = false;
    if (city == null || city.isEmpty() || !Pattern.matches("[A-Za-z\\s]+", city)) valid = false;
    if (state == null || state.isEmpty() || !Pattern.matches("[A-Za-z\\s]+", state)) valid = false;
    if (postalCode == null || postalCode.isEmpty() || !Pattern.matches("[A-Za-z0-9\\s]+", postalCode)) valid = false;
    if (country == null || country.isEmpty() || !Pattern.matches("[A-Za-z\\s]+", country)) valid = false;
    if (username == null || username.isEmpty() || username.length() < 5 || username.length() > 20) valid = false;
    if (password == null || password.isEmpty() || password.length() < 8) valid = false;

    if (!valid) {
%>
        <h1>Invalid input</h1>
        <p>Some of the information provided was invalid. Please go back and try again.</p>
        <a href="newAccount.jsp">Back to Registration</a>
<%
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Establish a connection to the database
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // SQL query to insert the new user into the database
            String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, firstName);
            pstmt.setString(2, lastName);
            pstmt.setString(3, email);
            pstmt.setString(4, phoneNumber);
            pstmt.setString(5, address);
            pstmt.setString(6, city);
            pstmt.setString(7, state);
            pstmt.setString(8, postalCode);
            pstmt.setString(9, country);
            pstmt.setString(10, username);
            pstmt.setString(11, password);

            // Execute the query
            int rowsInserted = pstmt.executeUpdate();

            if (rowsInserted > 0) {
%>
                <h1>Account Created Successfully!</h1>
                <p>Welcome, <%= firstName %>! Your account has been created.</p>
                <a href="login.jsp">Log In</a>
<%
            } else {
%>
                <h1>Account Creation Failed</h1>
                <p>Something went wrong. Please try again later.</p>
                <a href="newAccount.jsp">Back to Registration</a>
<%
            }
        } catch (Exception e) {
%>
            <h1>Error</h1>
            <p style="color: red;"><%= e.getMessage() %></p>
            <a href="newAccount.jsp">Back to Registration</a>
<%
        } finally {
            // Close resources
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

</body>
</html>
