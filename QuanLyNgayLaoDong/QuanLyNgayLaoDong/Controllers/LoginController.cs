using QuanLyNgayLaoDong.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace QuanLyNgayLaoDong.Controllers
{
    public class LoginController : Controller
    {
        private DB_QLNLD _contextdb = new DB_QLNLD();
        // GET: Account
        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginModel model)
        {
            if (ModelState.IsValid)
            {
                var user = CheckLogin(model.Username, model.Password);
                if (user != null)
                {
                    // Tạo ticket Forms Authentication
                    FormsAuthenticationTicket ticket = new FormsAuthenticationTicket(
                        1, // version
                        user.Username, // username
                        DateTime.Now,
                        DateTime.Now.AddMinutes(30), // thời hạn
                        false,
                        user.Role, // role nằm ở UserData
                        FormsAuthentication.FormsCookiePath
                    );

                    // Mã hóa ticket và tạo cookie
                    string encTicket = FormsAuthentication.Encrypt(ticket);
                    HttpCookie cookie = new HttpCookie(FormsAuthentication.FormsCookieName, encTicket);
                    Response.Cookies.Add(cookie);

                    // Điều hướng theo vai trò
                    switch (user.Role)
                    {
                        case "Admin":
                            return RedirectToAction("Index", "AdminHome", new { area = "Admin" });
                        case "QuanLy":
                            return RedirectToAction("Index", "TrangChu", new { area = "QuanLy" });
                        case "SinhVien":
                            return RedirectToAction("Index", "TrangChu", new { area = "SinhVien" });
                        case "LopTruong":
                            return RedirectToAction("Index", "TrangChu", new { area = "LopTruong" });
                        default:
                            return RedirectToAction("Login");
                    }
                }

                ModelState.AddModelError("", "Tài khoản hoặc mật khẩu không đúng.");
            }

            return View(model);
        }

        private User CheckLogin(string username, string password)
        {
            var account = _contextdb.TaiKhoans
                .Where(t => t.username == username && t.password == password)
                .FirstOrDefault();

            if (account != null)
            {
                var role = _contextdb.VaiTroes
                    .Where(v => v.vaitro_id == account.role_id)
                    .Select(v => v.vaitro1)
                    .FirstOrDefault();

                return new User
                {
                    TaiKhoanId = account.taikhoan_id,
                    Username = account.username,
                    Password = account.password,
                    Email = account.email,
                    Role = role
                };
            }

            return null;
        }

        public ActionResult Logout()
        {
            //return RedirectToAction("Login");
            FormsAuthentication.SignOut();
            return RedirectToAction("Login");
        }


        // khu vực dành cho quên mật khẩu

        public ActionResult ForgotPassword()
        {
            return View(); // Trả về View ForgotPassword.cshtml
        }

        [HttpPost]
        public ActionResult ForgotPassword(string email)
        {
            if (string.IsNullOrEmpty(email))
            {
                ViewBag.Message = "Vui lòng nhập địa chỉ email.";
                return View();
            }

            var user = _contextdb.TaiKhoans.FirstOrDefault(u => u.email == email);
            if (user == null)
            {
                ViewBag.Message = "Email không tồn tại trong hệ thống.";
                return View();
            }

            try
            {
                // Tạo token: email|timestamp -> base64
                string token = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(email + "|" + DateTime.Now));

                // Tạo đường dẫn reset
                string resetLink = Url.Action("ResetPassword", "Login", new { token = token }, Request.Url.Scheme);

                // Gửi email
                bool sent = EmailHelper.SendPasswordResetEmail(email, resetLink);

                if (sent)
                {
                    ViewBag.Message = "Email đặt lại mật khẩu đã được gửi đến địa chỉ của bạn.";
                }
                else
                {
                    ViewBag.Message = "Gửi email thất bại. Vui lòng thử lại sau.";
                }
            }
            catch (Exception ex)
            {
                ViewBag.Message = "Đã xảy ra lỗi: " + ex.Message;
            }

            return View();
        }


    }
}