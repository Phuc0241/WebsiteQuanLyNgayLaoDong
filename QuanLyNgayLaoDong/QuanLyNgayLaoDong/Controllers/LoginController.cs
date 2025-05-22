using QuanLyNgayLaoDong.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

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
                    model.Role = user.Role;
                    Session["User"] = user;

                    // Chuyển hướng dựa trên vai trò
                    if (user.Role == "Admin")
                    {
                        return RedirectToAction("Index", "AdminHome", new { area = "Admin" });
                    }
                    else if (user.Role == "QuanLy")
                    {
                        // Chuyển hướng cho các vai trò khác, ví dụ Admin
                        return RedirectToAction("Index", "TrangChu", new { area = "QuanLy" });
                    }
                    else if (user.Role == "SinhVien")
                    {
                        // Chuyển hướng cho các vai trò khác, ví dụ Admin
                        return RedirectToAction("Index", "TrangChu", new { area = "SinhVien" });
                    }
                    else
                    {
                        // Chuyển hướng cho các vai trò khác, ví dụ Admin
                        return RedirectToAction("Index", "TrangChu", new { area = "LopTruong" });
                    }
                }
                else
                {
                    ModelState.AddModelError("", "Tài khoản hoặc mật khẩu không đúng");
                }
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
            Session["User"] = null;
            return RedirectToAction("Login");
        }
    }
}