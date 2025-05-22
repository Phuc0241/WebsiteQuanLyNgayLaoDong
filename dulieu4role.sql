-- Bảng Khoa
CREATE TABLE Khoa( 
	khoa_id INT NOT NULL PRIMARY KEY,
	ma_khoa NVARCHAR(10) NOT NULL,
	ten_khoa NVARCHAR(255)
);

-- Bảng Lop
CREATE TABLE Lop (
	lop_id INT NOT NULL PRIMARY KEY,
	ma_lop NVARCHAR(20) NOT NULL,
	ten_lop NVARCHAR(255),
	khoa_id INT,
	CONSTRAINT fk_khoa FOREIGN KEY(khoa_id) REFERENCES Khoa(khoa_id)
);

-- Bảng VaiTro
CREATE TABLE VaiTro (
	vaitro_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	vaitro NVARCHAR(250)
);

-- Bảng TaiKhoan
CREATE TABLE TaiKhoan (
	taikhoan_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	username NVARCHAR(255),
	password NVARCHAR(255),
	email NVARCHAR(255),
	role_id INT,
	CONSTRAINT fk_taikhoan_role FOREIGN KEY(role_id) REFERENCES VaiTro(vaitro_id)
);

-- Bảng Anh
CREATE TABLE Anh (
	anh_id INT PRIMARY KEY IDENTITY(1,1),
	duongdan NVARCHAR(255) NOT NULL
);

-- Bảng SinhVien
CREATE TABLE SinhVien (
	MSSV INT NOT NULL PRIMARY KEY,
	hoten NVARCHAR(255) NOT NULL,
	ngaysinh DATE,
	quequan NVARCHAR(255),
	gioitinh BIT,
	taikhoan INT,
	SDT CHAR(15),
	lop_id INT,
	anh_id INT,
	CONSTRAINT fk_taikhoan FOREIGN KEY(taikhoan) REFERENCES TaiKhoan(taikhoan_id),
	CONSTRAINT fk_lop FOREIGN KEY(lop_id) REFERENCES Lop(lop_id),
	CONSTRAINT fk_anh FOREIGN KEY(anh_id) REFERENCES Anh(anh_id)
);

-- Bảng QuanLy
CREATE TABLE QuanLy (
	quanly_id INT NOT NULL PRIMARY KEY,
	hoten NVARCHAR(255),
	gioitinh BIT,
	diachi NVARCHAR(255),
	SDT CHAR(15),
	taikhoan INT,
	CONSTRAINT fk_quanly_taikhoan FOREIGN KEY(taikhoan) REFERENCES TaiKhoan(taikhoan_id)
);

-- Bảng TaoDotNgayLaoDong
CREATE TABLE TaoDotNgayLaoDong (
	ID INT PRIMARY KEY IDENTITY(1,1),
	TenDotLaoDong NVARCHAR(255) NOT NULL,
	MoTa NVARCHAR(500),
	NgayBatDau DATE NOT NULL,
	NgayKetThuc DATE NOT NULL,
	NgayTao DATETIME,
	NgayCapNhat DATETIME,
	NguoiTao INT,
	CONSTRAINT fk_dot_ngaylaodong_taikhoan FOREIGN KEY(NguoiTao) REFERENCES TaiKhoan(taikhoan_id)
);

-- Bảng PhieuDangKy
CREATE TABLE PhieuDangKy (
	id INT PRIMARY KEY,
	MSSV INT,
	LaoDongTheoLop BIT,
	LaoDongCaNhan BIT,
	ThoiGian DATETIME,
	CONSTRAINT fk_phieudk_sv FOREIGN KEY(MSSV) REFERENCES SinhVien(MSSV)
);

-- Bảng PhieuDuyet
CREATE TABLE PhieuDuyet (
	id INT PRIMARY KEY,
	Nguoiduyet INT,              -- QuanLy
	ThoiGian DATETIME,
	PhieuDangKy INT,
	CONSTRAINT fk_duyet_quanly FOREIGN KEY(Nguoiduyet) REFERENCES QuanLy(quanly_id),
	CONSTRAINT fk_duyet_phieu FOREIGN KEY(PhieuDangKy) REFERENCES PhieuDangKy(id)
);

-- Bảng PhieuXacNhanHoanThanh
CREATE TABLE PhieuXacNhanHoanThanh (
	id INT PRIMARY KEY,
	MSSV INT,
	phieuduyet INT,
	NguoiXacNhan INT,            -- QuanLy
	ThoiGian DATETIME,
	CONSTRAINT fk_xn_sv FOREIGN KEY(MSSV) REFERENCES SinhVien(MSSV),
	CONSTRAINT fk_xn_duyet FOREIGN KEY(phieuduyet) REFERENCES PhieuDuyet(id),
	CONSTRAINT fk_xn_quanly FOREIGN KEY(NguoiXacNhan) REFERENCES QuanLy(quanly_id)
);

-- Bảng SoNgayLaoDong
CREATE TABLE SoNgayLaoDong (
	id INT PRIMARY KEY,
	MSSV INT,
	TongSoNgay INT,
	Ma_phieu_xac_nhan INT,
	CONSTRAINT fk_songay_sv FOREIGN KEY(MSSV) REFERENCES SinhVien(MSSV),
	CONSTRAINT fk_songay_phieu FOREIGN KEY(Ma_phieu_xac_nhan) REFERENCES PhieuXacNhanHoanThanh(id)
);

--THÊM DỮ LIỆU
--Bảng Vai Trò
-- Thêm 4 vai trò mới
INSERT INTO VaiTro (vaitro) VALUES
(N'Admin'),          -- 1
(N'QuanLy'),         -- 2
(N'SinhVien'),       -- 3
(N'LopTruong');      -- 4





--Bảng Tài Khoản
-- Admin (1 account)
INSERT INTO TaiKhoan (username, password, email, role_id) VALUES
(N'admin', N'adminpass', 'admin@dthu.edu.vn', 1);

-- Người quản lý (2 accounts)
INSERT INTO TaiKhoan (username, password, email, role_id) VALUES
(N'quanly1', N'qlpass1', 'quanly1@dthu.edu.vn', 2),
(N'quanly2', N'qlpass2', 'quanly2@dthu.edu.vn', 2);

-- Sinh viên (10 accounts)
INSERT INTO TaiKhoan (username, password, email, role_id) VALUES
(N'0022410001', N'dthu10012003', '0022410001@student.dthu.edu.vn', 3),
(N'0022410002', N'dthu10012003', '0022410002@student.dthu.edu.vn', 3),
(N'0022410003', N'dthu10012003', '0022410003@student.dthu.edu.vn', 3),
(N'0022410004', N'dthu10012003', '0022410004@student.dthu.edu.vn', 3),
(N'0022410005', N'dthu10012003', '0022410005@student.dthu.edu.vn', 3),
(N'0022410006', N'dthu10012003', '0022410006@student.dthu.edu.vn', 3),
(N'0022410007', N'dthu10012003', '0022410007@student.dthu.edu.vn', 3),
(N'0022410008', N'dthu10012003', '0022410008@student.dthu.edu.vn', 3),
(N'0022410009', N'dthu10012003', '0022410009@student.dthu.edu.vn', 3),
(N'0022410010', N'dthu10012003', '0022410010@student.dthu.edu.vn', 3);

-- Lớp trưởng (2 accounts)
INSERT INTO TaiKhoan (username, password, email, role_id) VALUES
(N'0022410011', N'dthu10012003', '0022410011@student.dthu.edu.vn', 4),
(N'0022410012', N'dthu10012003', '0022410012@student.dthu.edu.vn', 4);






--Bảng Khoa
INSERT INTO Khoa (khoa_id, ma_khoa, ten_khoa) VALUES 
(1, 'CNTT', N'Công nghệ thông tin'),
(2, 'QTKD', N'Quản trị kinh doanh'),
(3, 'SPTO', N'Sư phạm Toán học'),
(4, 'DLNH', N'Du lịch - Nhà hàng'),
(5, 'NNAN', N'Ngôn ngữ Anh');

--Bảng Lớp
INSERT INTO Lop (lop_id, ma_lop, ten_lop, khoa_id) VALUES 
(1, 'DHKTPM16A', N'Kỹ thuật phần mềm 16A', 1),
(2, 'DHBQTKD01', N'Quản trị kinh doanh 01', 2),
(3, 'DHSPO2', N'Sư phạm Toán 02', 3),
(4, 'DHDLNH1', N'Du lịch - Nhà hàng 01', 4),
(5, 'DHNN01', N'Ngôn ngữ Anh 01', 5);

--Bảng Ảnh
INSERT INTO Anh (duongdan) VALUES 
(N'D:\BAO_CAO\MVC\avatar\man.png'),
(N'D:\BAO_CAO\MVC\avatar\man1.png'),
(N'D:\BAO_CAO\MVC\avatar\man2.png'),
(N'D:\BAO_CAO\MVC\avatar\girl.png'),
(N'D:\BAO_CAO\MVC\avatar\woman.png');

--Bảng Sinh Viên
-- Sinh viên
INSERT INTO SinhVien (MSSV, hoten, ngaysinh, quequan, gioitinh, taikhoan, SDT, lop_id, anh_id) VALUES
(0022410001, N'Nguyễn Văn An', '2002-01-01', N'Hà Nội', 1, 4, '0911111101', 1, 1),
(0022410002, N'Trần Thị Bảo Trân', '2002-02-02', N'Hải Phòng', 0, 5, '0911111102', 1, 2),
(0022410003, N'Lê Văn Chí', '2002-03-03', N'Nam Định', 1, 6, '0911111103', 1, 3),
(0022410004, N'Phạm Thị Dung', '2002-04-04', N'Ninh Bình', 0, 7, '0911111104', 1, 4),
(0022410005, N'Vũ Văn Tâm', '2002-05-05', N'Hưng Yên', 1, 8, '0911111105', 1, 5),
(0022410006, N'Đỗ Thị Mơ', '2002-06-06', N'Thanh Hóa', 0, 9, '0911111106', 1, 1),
(0022410007, N'Ngô Văn Trung', '2002-07-07', N'Nghệ An', 1, 10, '0911111107', 1, 2),
(0022410008, N'Hồ Thị Hà', '2002-08-08', N'Quảng Ngãi', 0, 11, '0911111108', 1, 3),
(0022410009, N'Tạ Minh Trí', '2002-09-09', N'Huế', 1, 12, '0911111109', 1, 4),
(0022410010, N'Lý Thị Kha', '2002-10-10', N'Bình Định', 0, 13, '0911111110', 1, 5),

-- Lớp trưởng
(0022410011, N'Nguyễn Văn Trưởng', '2002-11-11', N'Cà Mau', 1, 14, '0911111111', 1, 1),
(0022410012, N'Trần Thị Liên', '2002-12-12', N'Vĩnh Long', 0, 15, '0911111112', 1, 2);





--Bảng Quản Lý
-- Thêm lại dữ liệu quản lý tương ứng
INSERT INTO QuanLy (quanly_id, hoten,  gioitinh, diachi, SDT, taikhoan) VALUES
(1, N'Nguyễn Văn Quảng', 1, N'Hà Nội', '0901000001', 2),
(2, N'Trần Thị Lý', 0, N'Hồ Chí Minh', '0901000002', 3);
--INSERT INTO QuanLy (quanly_id, hoten, email, gioitinh, diachi, SDT, taikhoan) VALUES
--(1, N'Nguyễn Văn Quảng', 'nvquang@dthu.edu.vn', 1, N'Hà Nội', '0901000001', 2),
--(2, N'Trần Thị Lý', 'tlly@dthu.edu.vn', 0, N'Hồ Chí Minh', '0901000002', 3);

--Bảng tạo đợt lao động
INSERT INTO TaoDotNgayLaoDong (TenDotLaoDong, MoTa, NgayBatDau, NgayKetThuc, NgayTao, NgayCapNhat, NguoiTao) VALUES
(N'Dợt 1 - Vệ sinh lớp học', N'Dọn dẹp vệ sinh các phòng học', '2025-05-01', '2025-05-03', GETDATE(), GETDATE(), 1),
(N'Dợt 2 - Trồng cây sân trường', N'Trồng cây xanh quanh sân trường', '2025-05-05', '2025-05-07', GETDATE(), GETDATE(), 2),
(N'Dợt 3 - Vệ sinh khuôn viên', N'Vệ sinh khu vực nhà xe, sân', '2025-05-08', '2025-05-09', GETDATE(), GETDATE(), 3),
(N'Dợt 4 - Thu gom rác khu C', N'Lao động tập thể theo lớp', '2025-05-10', '2025-05-12', GETDATE(), GETDATE(), 1),
(N'Dợt 5 - Hỗ trợ hội thảo', N'Hỗ trợ tổ chức sự kiện hội thảo khoa học', '2025-05-13', '2025-05-14', GETDATE(), GETDATE(), 2),
(N'Dợt 6 - Thu gom rác khu A', N'Lao động tập thể theo lớp', '2025-05-15', '2025-05-16', GETDATE(), GETDATE(), 3),
(N'Dợt 7 - Trang trí lớp học', N'Trang trí lớp chào mừng ngày lễ', '2025-05-17', '2025-05-18', GETDATE(), GETDATE(), 1),
(N'Dợt 8 - Hỗ trợ thư viện', N'Sắp xếp tài liệu thư viện', '2025-05-19', '2025-05-20', GETDATE(), GETDATE(), 2);

-- Bảng phiếu đăng kí
INSERT INTO PhieuDangKy (id, MSSV, LaoDongTheoLop, LaoDongCaNhan, ThoiGian) VALUES
(1, 0022410011, 1, 0, GETDATE()),
(2, 0022410012, 1, 0, GETDATE()),
(3, 0022410011, 1, 0, GETDATE()),
(4, 0022410004, 0, 1, GETDATE()),
(5, 0022410005, 0, 1, GETDATE()),
(6, 0022410012, 1, 0, GETDATE()),
(7, 0022410007, 0, 1, GETDATE()),
(8, 0022410011, 1, 0, GETDATE());

-- Bảng phiếu duyệt
INSERT INTO PhieuDuyet (id, Nguoiduyet, ThoiGian, PhieuDangKy) VALUES
(1, 1, GETDATE(), 1),
(2, 2, GETDATE(), 2),
(3, 1, GETDATE(), 3),
(4, 2, GETDATE(), 4),
(5, 2, GETDATE(), 5),
(6, 1, GETDATE(), 6),
(7, 1, GETDATE(), 7),
(8, 2, GETDATE(), 8);

-- Bảng phiếu xác nhận hoàn thành
INSERT INTO PhieuXacNhanHoanThanh (id, MSSV, phieuduyet, NguoiXacNhan, ThoiGian) VALUES
(1, 0022410011, 1, 1, GETDATE()),
(2, 0022410012, 2, 2, GETDATE()),
(3, 0022410011, 3, 1, GETDATE()),
(4, 0022410004, 4, 2, GETDATE()),
(5, 0022410005, 5, 2, GETDATE()),
(6, 0022410012, 6, 1, GETDATE()),
(7, 0022410007, 7, 1, GETDATE()),
(8, 0022410011, 8, 2, GETDATE());

-- Bảng số ngày lao động tương ứng
INSERT INTO SoNgayLaoDong (id, MSSV, TongSoNgay, Ma_phieu_xac_nhan) VALUES
(1, 0022410011, 2, 1),
(2, 0022410012, 1, 2),
(3, 0022410011, 2, 3),
(4, 0022410004, 1, 4),
(5, 0022410005, 1, 5),
(6, 0022410012, 2, 6),
(7, 0022410007, 1, 7),
(8, 0022410011, 2, 8);
