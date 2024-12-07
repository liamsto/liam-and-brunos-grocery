<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
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
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        text-align: left;
    }
    table, th, td {
        border: 1px solid #ddd;
    }
    th, td {
        padding: 8px;
    }
    th {
        background-color: #f4f4f4;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9;
    }
    tr:hover {
        background-color: #f1f1f1;
    }
    .inventory-form {
            margin-top: 30px;
            text-align: center;
        }
        .inventory-form input {
            padding: 8px;
            font-size: 14px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .inventory-form button {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .inventory-form button:hover {
            background-color: #0056b3;
        }
        .inventory-table {
            margin-top: 30px;
            width: 100%;
            border-collapse: collapse;
        }
        .inventory-table th, .inventory-table td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }
        .inventory-table th {
            background-color: #f0f0f0;
        }
</style>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.math.BigDecimal" %>


<h1>Administrator Page</h1>

<%

    String sql = "SELECT CAST(orderDate AS DATE) AS OrderDate, SUM(totalAmount) AS TotalAmount " +
                 "FROM ordersummary " +
                 "GROUP BY CAST(orderDate AS DATE) " +
                 "ORDER BY OrderDate";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String user = "sa";
        String password = "304#sa#pw";
        conn = DriverManager.getConnection(url, user, password);
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        out.println("<table>");
        out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");
        while (rs.next()) {
            String orderDate = rs.getString("OrderDate");
            BigDecimal totalAmount = rs.getBigDecimal("TotalAmount");

            out.println("<tr>");
            out.println("<td>" + orderDate + "</td>");
            out.println("<td>" + totalAmount + "</td>");
            out.println("</tr>");
        }
        out.println("</table>");
    } catch (ClassNotFoundException e) {
        out.println("<p style='color: red;'>Error loading database driver: " + e.getMessage() + "</p>");
    } catch (SQLException e) {
        out.println("<p style='color: red;'>SQL Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>

</div>
</body>
</html>
