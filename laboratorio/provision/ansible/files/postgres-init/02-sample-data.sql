-- Dados de exemplo para testes de monitoramento (PostgreSQL)

-- Inserir clientes
INSERT INTO customers (name, email) VALUES
('João Silva', 'joao.silva@email.com'),
('Maria Santos', 'maria.santos@email.com'),
('Pedro Oliveira', 'pedro.oliveira@email.com'),
('Ana Costa', 'ana.costa@email.com'),
('Carlos Ferreira', 'carlos.ferreira@email.com')
ON CONFLICT (email) DO NOTHING;

-- Inserir produtos
INSERT INTO products (name, description, price, stock_quantity, category) VALUES
('Café Premium 1kg', 'Café arábica premium torrado e moído', 35.90, 150, 'cafe'),
('Café Gourmet 500g', 'Blend especial de cafés selecionados', 28.50, 200, 'cafe'),
('Chocolate Belga 200g', 'Chocolate belga 70% cacau', 22.90, 80, 'chocolate'),
('Chá Verde Orgânico', 'Chá verde orgânico 100g', 18.90, 120, 'cha'),
('Biscoito Amanteigado', 'Biscoito amanteigado artesanal 300g', 15.90, 95, 'biscoito'),
('Café Expresso Premium', 'Cápsulas de café expresso - 10 unidades', 42.90, 60, 'cafe'),
('Torta de Chocolate', 'Torta de chocolate caseira 500g', 45.00, 25, 'sobremesa'),
('Cappuccino Mix 250g', 'Mix para cappuccino cremoso', 24.90, 110, 'cafe')
ON CONFLICT DO NOTHING;

-- Inserir pedidos e itens
DO $$
DECLARE
    v_order_id INTEGER;
BEGIN
    -- Pedido 1
    INSERT INTO orders (customer_id, total_amount, status)
    VALUES (1, 58.80, 'completed')
    RETURNING order_id INTO v_order_id;

    INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (v_order_id, 1, 1, 35.90),
    (v_order_id, 4, 1, 18.90);

    -- Pedido 2
    INSERT INTO orders (customer_id, total_amount, status)
    VALUES (2, 91.70, 'processing')
    RETURNING order_id INTO v_order_id;

    INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (v_order_id, 6, 2, 42.90);

    -- Pedido 3
    INSERT INTO orders (customer_id, total_amount, status)
    VALUES (3, 68.80, 'completed')
    RETURNING order_id INTO v_order_id;

    INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (v_order_id, 7, 1, 45.00),
    (v_order_id, 5, 1, 15.90);

    -- Pedido 4
    INSERT INTO orders (customer_id, total_amount, status)
    VALUES (4, 22.90, 'pending')
    RETURNING order_id INTO v_order_id;

    INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
    (v_order_id, 3, 1, 22.90);
END $$;
