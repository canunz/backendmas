-- Migración para crear tablas de facturas
-- Fecha: 2025-06-30

-- Crear tabla facturas
CREATE TABLE IF NOT EXISTS `facturas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_factura` varchar(20) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `fecha_emision` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_vencimiento` datetime DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `iva` decimal(10,2) NOT NULL DEFAULT 0.00,
  `descuento` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL DEFAULT 0.00,
  `estado` enum('pendiente','pagada','vencida','cancelada') NOT NULL DEFAULT 'pendiente',
  `metodo_pago` varchar(50) DEFAULT NULL,
  `observaciones` text,
  `cliente_nombre` varchar(200) NOT NULL,
  `cliente_rut` varchar(20) DEFAULT NULL,
  `cliente_direccion` text,
  `cliente_email` varchar(100) DEFAULT NULL,
  `cliente_telefono` varchar(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_factura` (`numero_factura`),
  KEY `pedido_id` (`pedido_id`),
  KEY `cliente_id` (`cliente_id`),
  KEY `estado` (`estado`),
  KEY `fecha_emision` (`fecha_emision`),
  CONSTRAINT `fk_factura_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `pedidos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_factura_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `usuarios` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Crear tabla detalles_factura
CREATE TABLE IF NOT EXISTS `detalles_factura` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `factura_id` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `precio_unitario` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `descuento` decimal(10,2) NOT NULL DEFAULT 0.00,
  `iva` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total` decimal(10,2) NOT NULL,
  `producto_nombre` varchar(200) NOT NULL,
  `producto_codigo` varchar(50) DEFAULT NULL,
  `producto_descripcion` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `factura_id` (`factura_id`),
  KEY `producto_id` (`producto_id`),
  CONSTRAINT `fk_detalle_factura_factura` FOREIGN KEY (`factura_id`) REFERENCES `facturas` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_detalle_factura_producto` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insertar datos de ejemplo para métodos de pago si no existen
INSERT IGNORE INTO `metodos_pago` (`nombre`, `descripcion`, `activo`) VALUES
('efectivo', 'Pago en efectivo', 1),
('transferencia', 'Transferencia bancaria', 1),
('webpay', 'Webpay/Transbank', 1),
('tarjeta', 'Tarjeta de crédito/débito', 1),
('mercadopago', 'MercadoPago', 1);

-- Insertar factura de ejemplo
INSERT INTO `facturas` (
  `numero_factura`, 
  `pedido_id`, 
  `cliente_id`, 
  `fecha_emision`, 
  `fecha_vencimiento`,
  `subtotal`, 
  `iva`, 
  `descuento`, 
  `total`, 
  `estado`, 
  `metodo_pago`,
  `cliente_nombre`,
  `cliente_email`,
  `cliente_telefono`
) VALUES (
  'FAC-000001',
  1,
  1,
  NOW(),
  DATE_ADD(NOW(), INTERVAL 30 DAY),
  50000.00,
  9500.00,
  0.00,
  59500.00,
  'pagada',
  'efectivo',
  'Cliente Ejemplo',
  'cliente@ejemplo.com',
  '+56912345678'
);

-- Insertar detalle de factura de ejemplo
INSERT INTO `detalles_factura` (
  `factura_id`,
  `producto_id`,
  `cantidad`,
  `precio_unitario`,
  `subtotal`,
  `descuento`,
  `iva`,
  `total`,
  `producto_nombre`,
  `producto_codigo`,
  `producto_descripcion`
) VALUES (
  1,
  1,
  2,
  25000.00,
  50000.00,
  0.00,
  9500.00,
  59500.00,
  'Taladro Eléctrico DeWalt',
  'TAL-DEWALT-001',
  'Taladro eléctrico profesional de 20V'
); 