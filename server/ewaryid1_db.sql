-- phpMyAdmin SQL Dump
-- version 4.9.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Waktu pembuatan: 20 Des 2021 pada 22.15
-- Versi server: 10.3.27-MariaDB
-- Versi PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ewaryid1_db`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `news`
--

CREATE TABLE `news` (
  `id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `headline` varchar(250) NOT NULL,
  `content` varchar(500) NOT NULL,
  `author` varchar(50) NOT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `news`
--

INSERT INTO `news` (`id`, `title`, `headline`, `content`, `author`, `date`) VALUES
(1, 'Update App v1.0.2', 'v1.0.2', 'Please update your app version to 1.0.2, you\'ll enjoy the new features', 'Admin', '2021-12-16 04:10:11'),
(2, 'Update App v1.5.6', 'v1.5.6', 'Please update your app version 1.5.6', 'Admin', '2021-12-16 15:31:18');

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id` varchar(25) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `keterangan` varchar(250) DEFAULT NULL,
  `harga` int(11) NOT NULL,
  `gambar` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `produk`
--

INSERT INTO `produk` (`id`, `nama`, `keterangan`, `harga`, `gambar`) VALUES
('800142384392', 'Hair Energy Makarizo', '', 19000, '1/products/scaled_57f7a528-0616-4dbf-a81c-0fdb96d048076232651448552091056.jpg'),
('8993175536912', 'Nabati Siip', '', 3500, '1/products/scaled_image_picker8752376866483801693.webp'),
('8993417206122', 'Dry Shampoo Ellips', 'coba', 30000, '2/products/scaled_b1147720-c9b4-47db-b0d2-6f567e6413c16976957760271193960.jpg'),
('8997226224612', 'Hand Sanitizer Secret Clean 60mL', '', 15000, '1/products/scaled_1a405551-c460-4d29-98b3-bb4da00ae2889006132039245886097.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_toko`
--

CREATE TABLE `produk_toko` (
  `id` bigint(20) NOT NULL,
  `id_users` int(11) NOT NULL,
  `id_produk` varchar(25) NOT NULL,
  `nama` varchar(200) NOT NULL,
  `keterangan` varchar(250) DEFAULT NULL,
  `harga` int(11) NOT NULL,
  `stok` int(11) NOT NULL,
  `gambar` varchar(200) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `produk_toko`
--

INSERT INTO `produk_toko` (`id`, `id_users`, `id_produk`, `nama`, `keterangan`, `harga`, `stok`, `gambar`) VALUES
(52, 1, '8993175536912', 'Nabati Siip', '', 3500, 77, '1/products/scaled_image_picker8752376866483801693.webp'),
(53, 1, '800142384392', 'Hair Energy Makarizo', '', 19000, 41, '1/products/scaled_57f7a528-0616-4dbf-a81c-0fdb96d048076232651448552091056.jpg'),
(54, 1, '8997226224612', 'Hand Sanitizer Secret Clean 60mL', '', 15000, 336, '1/products/scaled_1a405551-c460-4d29-98b3-bb4da00ae2889006132039245886097.jpg'),
(55, 2, '8993417206122', 'Dry Shampoo Ellips1', 'coba1', 30001, 225, '2/products/scaled_image_picker2657897727690658231.jpg');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaction`
--

CREATE TABLE `transaction` (
  `id` bigint(20) NOT NULL,
  `id_users` int(11) NOT NULL,
  `bill` bigint(20) NOT NULL,
  `paid` bigint(20) NOT NULL,
  `change_bill` int(11) NOT NULL,
  `datetime_transaction` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `transaction`
--

INSERT INTO `transaction` (`id`, `id_users`, `bill`, `paid`, `change_bill`, `datetime_transaction`) VALUES
(6, 1, 110000, 110000, 0, '2021-12-17 22:24:24'),
(7, 1, 123500, 150000, 26500, '2021-12-17 22:25:07'),
(8, 2, 180006, 190000, 9994, '2021-12-19 08:52:32');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaction_detail`
--

CREATE TABLE `transaction_detail` (
  `id_transaction` bigint(20) NOT NULL,
  `id_produk` varchar(25) NOT NULL,
  `amount` int(11) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `transaction_detail`
--

INSERT INTO `transaction_detail` (`id_transaction`, `id_produk`, `amount`, `price`) VALUES
(6, '8993175536912', 10, 3500),
(6, '8997226224612', 5, 15000),
(7, '800142384392', 2, 19000),
(7, '8993175536912', 3, 3500),
(7, '8997226224612', 5, 15000),
(8, '8993417206122', 6, 30001);

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(200) NOT NULL,
  `nama` varchar(350) DEFAULT NULL,
  `alamat` varchar(500) DEFAULT NULL,
  `no_telp` varchar(15) DEFAULT NULL,
  `avatar` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `nama`, `alamat`, `no_telp`, `avatar`) VALUES
(1, '', 'toko@gmail.com', '10358c9adbf2c3829f34ae18c633c2d2', NULL, NULL, NULL, NULL),
(2, '', 'muhdadang@gmail.com', '202cb962ac59075b964b07152d234b70', NULL, NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `news`
--
ALTER TABLE `news`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `produk_toko`
--
ALTER TABLE `produk_toko`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produk_toko_ibfk_1` (`id_users`),
  ADD KEY `produk_toko_ibfk_2` (`id_produk`);

--
-- Indeks untuk tabel `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`id`),
  ADD KEY `transaction_ibfk_1` (`id_users`);

--
-- Indeks untuk tabel `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD KEY `id_transaction` (`id_transaction`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `news`
--
ALTER TABLE `news`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `produk_toko`
--
ALTER TABLE `produk_toko`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT untuk tabel `transaction`
--
ALTER TABLE `transaction`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `produk_toko`
--
ALTER TABLE `produk_toko`
  ADD CONSTRAINT `produk_toko_ibfk_1` FOREIGN KEY (`id_users`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `produk_toko_ibfk_2` FOREIGN KEY (`id_produk`) REFERENCES `produk` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`id_users`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD CONSTRAINT `detail_transaction_ibfk_1` FOREIGN KEY (`id_transaction`) REFERENCES `transaction` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
