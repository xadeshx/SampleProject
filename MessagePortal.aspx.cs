using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SampleProject
{
    public partial class MessagePortal : Page
    {
        // In-memory storage for messages (replace with database in production)
        private static List<Message> messages = new List<Message>();

        public class Message
        {
            public int Id { get; set; }
            public string Sender { get; set; }
            public string Recipient { get; set; }
            public string Content { get; set; }
            public DateTime Timestamp { get; set; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMessages();
                UpdateStats();
            }
        }

        private void LoadMessages()
        {
            // Bind messages to repeater
            rptMessages.DataSource = messages.OrderByDescending(m => m.Timestamp).ToList();
            rptMessages.DataBind();

            // Show/hide empty message
            emptyMessage.Visible = messages.Count == 0;
        }

        private void UpdateStats()
        {
            // Update message count
            lblMessageCount.Text = messages.Count.ToString();

            // Update unique user count
            int uniqueUsers = messages.Select(m => m.Sender).Distinct().Count();
            lblUserCount.Text = uniqueUsers.ToString();
        }

        protected void btnSend_Click(object sender, EventArgs e)
        {
            // Validate inputs
            if (string.IsNullOrWhiteSpace(txtSender.Text))
            {
                ShowAlert("Please enter your name");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtRecipient.Text))
            {
                ShowAlert("Please enter recipient name");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtMessage.Text))
            {
                ShowAlert("Please type a message");
                return;
            }

            try
            {
                // Create new message
                var newMessage = new Message
                {
                    Id = messages.Count > 0 ? messages.Max(m => m.Id) + 1 : 1,
                    Sender = Server.HtmlEncode(txtSender.Text.Trim()),
                    Recipient = Server.HtmlEncode(txtRecipient.Text.Trim()),
                    Content = Server.HtmlEncode(txtMessage.Text.Trim()),
                    Timestamp = DateTime.Now
                };

                // Add to collection
                messages.Add(newMessage);

                // Clear form
                ClearForm();

                // Reload messages
                LoadMessages();
                UpdateStats();

                // Show success message
                ShowSuccessMessage();
            }
            catch (Exception ex)
            {
                ShowAlert("Error sending message: " + ex.Message);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        private void ClearForm()
        {
            txtSender.Text = string.Empty;
            txtRecipient.Text = string.Empty;
            txtMessage.Text = string.Empty;
            txtSender.Focus();
        }

        private void ShowSuccessMessage()
        {
            successMsg.Style.Add("display", "block");
            // Hide after 3 seconds using client-side script
            ScriptManager.RegisterStartupScript(this, GetType(), "hideSuccess",
                "setTimeout(function() { document.getElementById('" + successMsg.ClientID + "').style.display = 'none'; }, 3000);",
                true);
        }

        private void ShowAlert(string message)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert",
                "alert('" + message.Replace("'", "\\'") + "');", true);
        }

        // Optional: Method to get messages by sender
        public List<Message> GetMessagesBySender(string sender)
        {
            return messages.Where(m => m.Sender == sender).OrderByDescending(m => m.Timestamp).ToList();
        }

        // Optional: Method to get messages by recipient
        public List<Message> GetMessagesByRecipient(string recipient)
        {
            return messages.Where(m => m.Recipient == recipient).OrderByDescending(m => m.Timestamp).ToList();
        }

        // Optional: Method to delete a message
        public bool DeleteMessage(int messageId)
        {
            var message = messages.FirstOrDefault(m => m.Id == messageId);
            if (message != null)
            {
                messages.Remove(message);
                return true;
            }
            return false;
        }

        // Optional: Method to clear all messages
        public void ClearAllMessages()
        {
            messages.Clear();
        }
    }
}
