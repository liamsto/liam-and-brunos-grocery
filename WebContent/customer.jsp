<!DOCTYPE html>
<html>
<head>
    <title>Customer Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f0f0f0;
        }
        h1 {
            text-align: center;
        }
        table {
            width: 50%;
            margin: 20px auto;
            border-collapse: collapse;
            text-align: left;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
        }
        th {
            background-color: #007bff;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .error-message {
            color: red;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
%>
<div class="error-message">
    <p>Error: You must be logged in to access this page.</p>
</div>
<%
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String user = "sa";
            String password = "304#sa#pw";
            conn = DriverManager.getConnection(url, user, password);

            String sql = "SELECT userid, firstName, lastName, email, phonenum, address, city, state, postalCode, country " +
                         "FROM customer WHERE userid = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userName);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                String userId = rs.getString("userid");
                String firstName = rs.getString("firstName");
                String lastName = rs.getString("lastName");
                String email = rs.getString("email");
                String phone = rs.getString("phonenum");
                String address = rs.getString("address");
                String city = rs.getString("city");
                String state = rs.getString("state");
                String postalCode = rs.getString("postalCode");
                String country = rs.getString("country");
%>
<h1>Customer Information</h1>
<table>
    <tr>
        <th>Field</th>
        <th>Details</th>
    </tr>
    <tr>
        <td>User ID</td>
        <td><%= userId %></td>
    </tr>
    <tr>
        <td>First Name</td>
        <td><%= firstName %></td>
    </tr>
    <tr>
        <td>Last Name</td>
        <td><%= lastName %></td>
    </tr>
    <tr>
        <td>Email</td>
        <td><%= email %></td>
    </tr>
    <tr>
        <td>Phone</td>
        <td><%= phone %></td>
    </tr>
    <tr>
        <td>Address</td>
        <td><%= address %>, <%= city %>, <%= state %>, <%= postalCode %>, <%= country %></td>
    </tr>
</table>
<%
            } else {
%>
<div class="error-message">
    <p>No info found.</p>
</div>
<%
            }
        } catch (SQLException | ClassNotFoundException e) {
%>
<div class="error-message">
    <p>Error: <%= e.getMessage() %></p>
</div>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

</body>
</html>
