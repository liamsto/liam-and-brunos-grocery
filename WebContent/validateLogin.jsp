<%@ page language="java" import="java.io.*,java.sql.*,java.util.HashMap,java.util.ArrayList,java.math.BigDecimal" %>
<%@ include file="jdbc.jsp" %>
<%
    String authenticatedUser = null;
    session = request.getSession(true);

    try {
        authenticatedUser = validateLogin(out, request, session);
    } catch (IOException e) {
        System.err.println(e);
    }

    if (authenticatedUser != null) {
        // Load the cart for the user
        loadCart(authenticatedUser, session);
        response.sendRedirect("index.jsp"); // successful - redirect to admin page
    } else {
        response.sendRedirect("login.jsp"); // failed - kick them back to login page
    }
%>

<%!
    String validateLogin(JspWriter out, HttpServletRequest request, HttpSession session) throws IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String retStr = null;

        if (username == null || password == null)
            return null;
        if (username.length() == 0 || password.length() == 0)
            return null;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);
            String sql = "SELECT userid FROM customer WHERE userid = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                retStr = username;
            }
        } catch (SQLException | ClassNotFoundException ex) {
            out.println("<p style='color:red;'>Database Error: " + ex.getMessage() + "</p>");
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }

        if (retStr != null) {
            session.removeAttribute("loginMessage");
            session.setAttribute("authenticatedUser", username);
        } else {
            session.setAttribute("loginMessage", "Invalid username or password.");
        }

        return retStr;
    }

    void loadCart(String userId, HttpSession session) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // Database connection
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String dbUser = "sa";
            String dbPassword = "304#sa#pw";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // Query to load the cart for the user
            String loadCartQuery = "SELECT productId, quantity, price FROM cart WHERE userId = ?";
            pstmt = conn.prepareStatement(loadCartQuery);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            // Initialize a HashMap to store the cart
            HashMap<String, ArrayList<Object>> productList = new HashMap<>();

            while (rs.next()) {
                String productId = rs.getString("productId");
                int quantity = rs.getInt("quantity");
                BigDecimal price = rs.getBigDecimal("price");

                // Store each product as an ArrayList
                ArrayList<Object> product = new ArrayList<>();
                product.add(productId); // Product ID
                product.add(quantity); // Quantity
                product.add(price);    // Price

                productList.put(productId, product);
            }

            // Store the cart in the session
            session.setAttribute("productList", productList);
        } catch (Exception e) {
            System.err.println("Error loading cart: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ignored) {}
        }
    }
%>
