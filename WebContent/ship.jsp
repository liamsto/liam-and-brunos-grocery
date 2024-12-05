<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Liam's Grocery Shipment Processing</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background-color: #f0f0f0;
    }
    header {
        background-color: #007bff;
        color: white;
        padding: 20px 0;
        text-align: center;
        font-size: 2em;
    }
    .message, .error {
        text-align: center;
        font-size: 1.2em;
        margin-top: 20px;
    }
    .message {
        color: green;
    }
    .error {
        color: red;
    }
    h1 {
        text-align: center;
        margin-top: 20px;
    }
    h2 {
        text-align: center;
        margin-top: 20px;
    }
    a {
        display: inline-block;
        margin: 10px auto;
        padding: 10px 20px;
        color: white;
        background-color: #007bff;
        text-decoration: none;
        border-radius: 5px;
        font-size: 1.2em;
        transition: background-color 0.3s;
    }
    a:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>

<header>Liam's Grocery Shipment Processing</header>

<h1>Shipment Processing</h1>

<%
    String orderIdParam = request.getParameter("orderId");
    if (orderIdParam == null || orderIdParam.isEmpty()) {
%>
    <div class="error">Error: No order ID provided.</div>
<%
    } else {
        int orderId = Integer.parseInt(orderIdParam);
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String user = "sa";
            String password = "304#sa#pw";
            conn = DriverManager.getConnection(url, user, password);

            String orderCheckQuery = "SELECT * FROM ordersummary WHERE orderId = ?";
            pstmt = conn.prepareStatement(orderCheckQuery);
            pstmt.setInt(1, orderId);
            rs = pstmt.executeQuery();

            if (!rs.next()) {
%>
    <div class="error">Error: Invalid order ID. No orders with that ID found!</div>
<%
            } else {
                conn.setAutoCommit(false);
                String orderItemsQuery = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
                pstmt = conn.prepareStatement(orderItemsQuery);
                pstmt.setInt(1, orderId);
                rs = pstmt.executeQuery();


                ArrayList<Map<String, Integer>> items = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Integer> item = new HashMap<>();
                    item.put("productId", rs.getInt("productId"));
                    item.put("quantity", rs.getInt("quantity"));
                    items.add(item);
                }

                String shipmentInsertQuery = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (GETDATE(), ?, 1)";
                pstmt = conn.prepareStatement(shipmentInsertQuery, Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, "Shipment for Order ID: " + orderId);
                pstmt.executeUpdate();
                rs = pstmt.getGeneratedKeys();
                int shipmentId = 0;
                if (rs.next()) {
                    shipmentId = rs.getInt(1);
                }

                boolean sufficientInventory = true;
                for (Map<String, Integer> item : items) {
                    int productId = item.get("productId");
                    int quantity = item.get("quantity");

                    //ensure we have enough inventory, if not rollback and display error
                    String inventoryCheckQuery = "SELECT quantity FROM productinventory WHERE productId = ? AND warehouseId = 1";
                    pstmt = conn.prepareStatement(inventoryCheckQuery);
                    pstmt.setInt(1, productId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        int availableQuantity = rs.getInt("quantity");
                        if (availableQuantity < quantity) {
                            sufficientInventory = false;
                            break;
                        } else {
                            String inventoryUpdateQuery = "UPDATE productinventory SET quantity = quantity - ? WHERE productId = ? AND warehouseId = 1";
                            pstmt = conn.prepareStatement(inventoryUpdateQuery);
                            pstmt.setInt(1, quantity);
                            pstmt.setInt(2, productId);
                            pstmt.executeUpdate();
                        }
                    } else {
                        sufficientInventory = false;
                        break;
                    }
                }

                if (sufficientInventory) {
                    conn.commit();
%>
    <div class="message">Shipment completed! Shipment ID: <%= shipmentId %></div>
<%
                } else {
                    //resets inventory if there is not enough inventory
                    conn.rollback();
%>
    <div class="error">Error: Insufficient inventory for one or more items. Shipment canceled.</div>
<%
                }
                conn.setAutoCommit(true);
            }
        } catch (SQLException | ClassNotFoundException e) {
%>
    <div class="error">Error: <%= e.getMessage() %></div>
<%
            try {
                if (conn != null) conn.rollback(); 
            } catch (SQLException ignored) {}
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    }
%>

<h2><a href="shop.html">Back to Home</a></h2>

</body>
</html>
