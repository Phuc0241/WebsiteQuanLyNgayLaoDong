using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QuanLyNgayLaoDong.Areas.SinhVien.Controllers
{
    public class TrangChuController : Controller
    {
        // GET: SinhVien/TrangChu
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult TrangThongTinSinhVien()
        {
            return View();
        }
    }
}