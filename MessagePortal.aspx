<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MessagePortal.aspx.cs" Inherits="SampleProject.MessagePortal" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Message Portal</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 900px;
            height: 600px;
            display: flex;
            overflow: hidden;
        }

        .messages-section {
            flex: 1;
            border-right: 1px solid #e0e0e0;
            display: flex;
            flex-direction: column;
        }

        .header {
            background: #667eea;
            color: white;
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid #5568d3;
        }

        .header h1 {
            font-size: 24px;
            margin-bottom: 5px;
        }

        .header p {
            font-size: 12px;
            opacity: 0.9;
        }

        .messages-list {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
            background: #f9f9f9;
        }

        .message-item {
            margin-bottom: 15px;
            padding: 12px;
            background: white;
            border-left: 4px solid #667eea;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }

        .message-item:hover {
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transform: translateX(5px);
        }

        .message-sender {
            font-weight: bold;
            color: #667eea;
            font-size: 12px;
            margin-bottom: 5px;
        }

        .message-content {
            color: #333;
            font-size: 14px;
            line-height: 1.4;
        }

        .message-time {
            font-size: 10px;
            color: #999;
            margin-top: 8px;
        }

        .compose-section {
            padding: 20px;
            background: white;
            border-top: 1px solid #e0e0e0;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-family: inherit;
            font-size: 13px;
            resize: none;
        }

        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 5px rgba(102, 126, 234, 0.3);
        }

        .form-group textarea {
            min-height: 80px;
        }

        .button-group {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        button {
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            font-size: 13px;
            transition: all 0.3s ease;
        }

        .btn-send {
            background: #667eea;
            color: white;
        }

        .btn-send:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }

        .btn-clear {
            background: #f0f0f0;
            color: #333;
        }

        .btn-clear:hover {
            background: #e0e0e0;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 12px;
            border-radius: 4px;
            margin-bottom: 15px;
            display: none;
        }

        .info-section {
            width: 300px;
            padding: 20px;
            background: #f5f5f5;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .info-box {
            background: white;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        .info-box h3 {
            color: #667eea;
            font-size: 14px;
            margin-bottom: 10px;
            border-bottom: 2px solid #667eea;
            padding-bottom: 8px;
        }

        .info-box p {
            font-size: 12px;
            color: #666;
            line-height: 1.6;
        }

        .stats {
            display: flex;
            justify-content: space-around;
            padding: 15px;
            background: white;
            border-radius: 4px;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 24px;
            font-weight: bold;
            color: #667eea;
        }

        .stat-label {
            font-size: 11px;
            color: #999;
            margin-top: 5px;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
                height: auto;
            }

            .messages-section {
                border-right: none;
                border-bottom: 1px solid #e0e0e0;
                height: 400px;
            }

            .info-section {
                width: 100%;
                order: 3;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <!-- Messages Section -->
            <div class="messages-section">
                <div class="header">
                    <h1>📨 Message Portal</h1>
                    <p>Manage your messages in one place</p>
                </div>

                <div class="messages-list">
                    <asp:Repeater ID="rptMessages" runat="server">
                        <ItemTemplate>
                            <div class="message-item">
                                <div class="message-sender">✉️ <%# Eval("Sender") %></div>
                                <div class="message-content"><%# Eval("Content") %></div>
                                <div class="message-time"><%# ((DateTime)Eval("Timestamp")).ToString("MMM dd, yyyy HH:mm") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div id="emptyMessage" runat="server" style="text-align: center; color: #999; padding: 40px 20px;">
                        <p style="font-size: 14px;">No messages yet. Send your first message!</p>
                    </div>
                </div>
            </div>

            <!-- Compose Section & Info -->
            <div style="flex: 1; display: flex; flex-direction: column;">
                <div class="compose-section">
                    <div class="success-message" id="successMsg" runat="server">
                        ✓ Message sent successfully!
                    </div>

                    <div class="form-group">
                        <label for="txtSender">From:</label>
                        <asp:TextBox ID="txtSender" runat="server" placeholder="Your name" />
                    </div>

                    <div class="form-group">
                        <label for="txtRecipient">To:</label>
                        <asp:TextBox ID="txtRecipient" runat="server" placeholder="Recipient name" />
                    </div>

                    <div class="form-group">
                        <label for="txtMessage">Message:</label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" placeholder="Type your message here..." />
                    </div>

                    <div class="button-group">
                        <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn-clear" OnClick="btnClear_Click" />
                        <asp:Button ID="btnSend" runat="server" Text="Send Message" CssClass="btn-send" OnClick="btnSend_Click" />
                    </div>
                </div>

                <!-- Info Section -->
                <div class="info-section">
                    <div>
                        <div class="info-box">
                            <h3>💡 Features</h3>
                            <p>• Send messages instantly<br/>• View message history<br/>• Track timestamps<br/>• User-friendly interface</p>
                        </div>

                        <div class="stats">
                            <div class="stat-item">
                                <div class="stat-number">
                                    <asp:Label ID="lblMessageCount" runat="server" Text="0" />
                                </div>
                                <div class="stat-label">Messages</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-number">
                                    <asp:Label ID="lblUserCount" runat="server" Text="0" />
                                </div>
                                <div class="stat-label">Users</div>
                            </div>
                        </div>
                    </div>

                    <div class="info-box">
                        <h3>ℹ️ About</h3>
                        <p>This is a simple message portal for managing communications. Start by composing a new message on the left.</p>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
