-- sql/01_schema.sql
-- Tables, primary/foreign keys and constraints (Item, Supplier, Staff, ServiceActivity, StockMovement, StockMovementLine, ItemSupplier).
-- Run with comp2411_g069 selected as the active database.


CREATE TABLE Item (
	item_id INT NOT NULL AUTO_INCREMENT,
	item_code VARCHAR(20) NOT NULL,
	item_name VARCHAR(100) NOT NULL,
	unit VARCHAR(10) NOT NULL,
	reorder_level INT NOT NULL,
	PRIMARY KEY (item_id),
	UNIQUE KEY unique_item_code (item_code),
	CONSTRAINT check_item_reorder CHECK (reorder_level >= 0),
	CONSTRAINT check_item_unit CHECK (unit in ('pcs','g','mL','pair'))
);

CREATE TABLE Supplier (
	supplier_id INT NOT NULL AUTO_INCREMENT,
	supplier_name VARCHAR(100) NOT NULL,
	phone VARCHAR(20) NULL,
	email VARCHAR(100) NULL,
	PRIMARY KEY(supplier_id)
);

CREATE TABLE Staff (
	staff_id INT NOT NULL AUTO_INCREMENT,
	staff_name VARCHAR(100) NOT NULL,
	role VARCHAR(20) NOT NULL,
	PRIMARY KEY (staff_id),
	CONSTRAINT check_staff_role CHECK (role IN ('STOCK_KEEPER', 'GROOMER', 'KENNEL_STAFF', 'MANAGER'))
);

CREATE TABLE ServiceActivity (
	activity_id INT NOT NULL AUTO_INCREMENT,
	activity_ref VARCHAR(20) NOT NULL,
	activity_type VARCHAR(10) NOT NULL,
	service_date DATE NOT NULL,
	PRIMARY KEY (activity_id),
	UNIQUE KEY unique_activity_ref (activity_ref),
	CONSTRAINT check_activity_type CHECK (activity_type IN ('BOARDING', 'GROOMING'))
);

CREATE TABLE StockMovement(
	movement_id INT NOT NULL AUTO_INCREMENT,
	movement_type VARCHAR(7) NOT NULL,
	movement_datetime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	staff_id INT NOT NULL,
	supplier_id INT NULL,
	activity_id INT NULL,
	PRIMARY KEY(movement_id),
	CONSTRAINT fk_stockmovement_staff
		FOREIGN KEY (staff_id) REFERENCES Staff(staff_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_stockmovement_supplier
		FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_stockmovement_activity
		FOREIGN KEY (activity_id) REFERENCES ServiceActivity(activity_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT check_br03 CHECK (
		(movement_type = 'RECEIPT' AND supplier_id IS NOT NULL AND activity_id IS NULL)
		OR
		(movement_type = 'ISSUE' AND activity_id IS NOT NULL AND supplier_id IS NULL)),
	CONSTRAINT check_movement_type CHECK(movement_type IN ('RECEIPT', 'ISSUE'))
);

CREATE TABLE StockMovementLine(
	movement_id INT NOT NULL,
	item_id INT NOT NULL,
	quantity INT NOT NULL,
	PRIMARY KEY (movement_id, item_id),
	CONSTRAINT fk_stockmovementline_movement
		FOREIGN KEY (movement_id) REFERENCES StockMovement(movement_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_stockmovementline_item
		FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT check_quantity CHECK(quantity > 0)
);

CREATE TABLE ItemSupplier(
	item_id INT NOT NULL,
	supplier_id INT NOT NULL,
	supplier_item_code VARCHAR(30) NOT NULL,
	unit_price DECIMAL(12,4) NULL,
	PRIMARY KEY(item_id, supplier_id),
	UNIQUE KEY unique_supplier_item_code (supplier_id, supplier_item_code),
	CONSTRAINT fk_itemsupplier_item
		FOREIGN KEY (item_id) REFERENCES Item(item_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT fk_itemsupplier_supplier
		FOREIGN KEY (supplier_id) REFERENCES Supplier(supplier_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
	CONSTRAINT check_unitprice CHECK(unit_price >= 0)
);
