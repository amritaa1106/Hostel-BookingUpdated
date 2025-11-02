<%
System.out.println("JSP login block executing...");

// Only process login if it's a POST request
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String role = request.getParameter("role");
    String message = null;

    if (email != null && password != null && role != null) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hostel_booking_system", "root", "Discodisco11*");

            PreparedStatement ps = null;
            if (role.equals("admin")) {
                ps = conn.prepareStatement("SELECT * FROM admins WHERE email=? AND password=?");
            } else {
                ps = conn.prepareStatement("SELECT * FROM students WHERE email=? AND password=?");
            }

            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ User found, create session and redirect
                session.setAttribute("userEmail", email);
                session.setAttribute("userRole", role);

                if (role.equals("admin")) {
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    session.setAttribute("studentEmail", email);
                    response.sendRedirect("student"); // servlet
                }

                conn.close();
                return; // Stop JSP from continuing after redirect
            } else {
                message = "Invalid email or password.";
            }

            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        }

        // ✅ Store message in request to display
        request.setAttribute("message", message);
    } // close email/password/role check
} // close POST check
%>
