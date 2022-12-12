--In ra danh sách các sản phẩm (MASP,TENSP) không bán được.
SELECT MASP, TENSP
FROM  SANPHAM
WHERE MASP NOT IN ( SELECT MASP
     FROM  CTHD)

--In ra danh sách các sản phẩm (MASP,TENSP) không bán được trong năm 2006.
SELECT MASP, TENSP
FROM  SANPHAM
WHERE MASP NOT IN ( SELECT A.MASP
     FROM  CTHD A, HOADON B
     WHERE A.SOHD=B.SOHD AND YEAR(NGHD)=2006)

--In ra danh sách các sản phẩm (MASP,TENSP) do “Trung Quoc” sản xuất không bán được trong
--năm 2006.
SELECT MASP, TENSP
FROM  SANPHAM
WHERE NUOCSX='TRUNG QUOC' AND
  MASP NOT IN ( SELECT A.MASP
     FROM  CTHD A, HOADON B
     WHERE A.SOHD=B.SOHD AND YEAR(NGHD)=2006)
-- Tìm số hóa đơn đã mua tất cả các sản phẩm do Singapore sản xuất.
SELECT DISTINCT SOHD
FROM  CTHD A
WHERE NOT EXISTS(SELECT *
    FROM  SANPHAM B
    WHERE NUOCSX='SINGAPORE' AND
      NOT EXISTS(SELECT *
        FROM  CTHD C
        WHERE C.MASP=B.MASP AND C.SOHD=A.SOHD))
--Tìm số hóa đơn trong năm 2006 đã mua ít nhất tất cả các sản phẩm do Singapore sản xuất.
SELECT H.SOHD 
FROM HOADON H
WHERE YEAR(NGHD) = 2006 AND NOT EXISTS(SELECT *
FROM SANPHAM S
WHERE NUOCSX = 'SINGAPORE'
AND NOT EXISTS(SELECT * 
FROM CTHD C
WHERE C.SOHD = H.SOHD
AND C.MASP = S.MASP))
-- Có bao nhiêu hóa đơn không phải của khách hàng đăng ký thành viên mua?
SELECT COUNT(SOHD)
FROM  HOADON
WHERE MAKH IS NULL
--Có bao nhiêu sản phẩm khác nhau được bán ra trong năm 2006.
SELECT COUNT(DISTINCT MASP)
FROM  HOADON A, CTHD B
WHERE A.SOHD=B.SOHD AND YEAR(NGHD)=2006
-- Cho biết trị giá hóa đơn cao nhất, thấp nhất là bao nhiêu ?
SELECT MAX(TRIGIA) [TRI GIA CAO NHAT],MIN(TRIGIA) [TRI GIA THAP NHAT] 
FROM  HOADON
-- Trị giá trung bình của tất cả các hóa đơn được bán ra trong năm 2006 là bao nhiêu?
SELECT AVG(TRIGIA)
FROM  HOADON
WHERE YEAR(NGHD)=2006
--Tính doanh thu bán hàng trong năm 2006.
SELECT SUM(TRIGIA) [DOANH THU]
FROM  HOADON
WHERE YEAR(NGHD)=2006
--Tìm số hóa đơn có trị giá cao nhất trong năm 2006.
SELECT SOHD
FROM HOADON
WHERE TRIGIA = (SELECT MAX(TRIGIA)
FROM HOADON)
-- Tìm họ tên khách hàng đã mua hóa đơn có trị giá cao nhất trong năm 2006.
SELECT HOTEN
FROM KHACHHANG K INNER JOIN HOADON H
ON K.MAKH = H.MAKH 
AND SOHD = (SELECT SOHD
			FROM HOADON
			WHERE TRIGIA = (SELECT MAX(TRIGIA)
							FROM HOADON))
--In ra danh sách 3 khách hàng (MAKH, HOTEN) có doanh số cao nhất.
SELECT *
FROM  KHACHHANG
WHERE DOANHSO IN(SELECT TOP 3 DOANHSO
    FROM   KHACHHANG
    ORDER BY   DOANHSO DESC)  

--In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá cao nhất.
SELECT *
FROM  SANPHAM
WHERE GIA IN(SELECT TOP 3  GIA
    FROM   SANPHAM
    ORDER BY   GIA DESC)
	--In ra danh sách các sản phẩm (MASP, TENSP) do “Thai Lan” sản xuất có giá bằng 1 trong 3 mức
--giá cao nhất (của tất cả các sản phẩm).
SELECT *
FROM  SANPHAM
WHERE NUOCSX='THAI LAN' AND GIA IN(SELECT TOP 3  GIA
        FROM   SANPHAM
        ORDER BY   GIA DESC) 
--In ra danh sách các sản phẩm (MASP, TENSP) do “Trung Quoc” sản xuất có giá bằng 1 trong 3 mức
--giá cao nhất (của sản phẩm do “Trung Quoc” sản xuất).
SELECT *
FROM  SANPHAM
WHERE NUOCSX='TRUNG QUOC' AND GIA IN(SELECT TOP 3  GIA
        FROM   SANPHAM
        WHERE  NUOCSX='TRUNG QUOC'
        ORDER BY   GIA DESC) 
--	* In ra danh sách 3 khách hàng có doanh số cao nhất (sắp xếp theo kiểu xếp hạng).
SELECT TOP 3 MAKH, HOTEN
FROM KHACHHANG
ORDER BY DOANHSO DESC
--	Tính tổng số sản phẩm do “Trung Quoc” sản xuất.
SELECT COUNT(DISTINCT MASP)
FROM SANPHAM
WHERE NUOCSX = 'TRUNG QUOC'
--	Tính tổng số sản phẩm của từng nước sản xuất.
SELECT NUOCSX, COUNT(DISTINCT MASP) AS TONGSOSANPHAM
FROM SANPHAM
GROUP BY NUOCSX
--Với từng nước sản xuất, tìm giá bán cao nhất, thấp nhất, trung bình của các sản phẩm.
SELECT NUOCSX, MAX(GIA) AS MAX, MIN(GIA) AS MIN, AVG(GIA) AS AVG
FROM SANPHAM
GROUP BY NUOCSX
--Tính doanh thu bán hàng mỗi ngày.
SELECT NGHD, SUM(TRIGIA) AS DOANHTHU
FROM HOADON
GROUP BY NGHD