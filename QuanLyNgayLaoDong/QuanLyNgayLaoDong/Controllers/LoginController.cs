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
    }
}