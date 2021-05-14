﻿using System;
using System.Collections.Generic;
using System.Linq;

namespace NerdStore.Vendas.Domain
{
    public class Pedido
    {
        protected Pedido()
        {
            _pedidoItems = new List<PedidoItem>();
        }
        public Guid ClienteId { get; private set; }

        private readonly List<PedidoItem> _pedidoItems;
        public decimal ValorTotal { get; private set; }
        public PedidoStatus PedidoStatus { get; private set; }
        public IReadOnlyCollection<PedidoItem> PedidoItems => _pedidoItems;

        public void CalcularValorPedido() =>
            ValorTotal = PedidoItems.Sum(i => i.CalcularValor());

        public void TornarRascunho() =>
            PedidoStatus = PedidoStatus.Rascunho;

        public void AdicionarItem(PedidoItem pedidoItem)
        {
            if (_pedidoItems.Any(p => p.ProdutoId == pedidoItem.ProdutoId))
            {
                var itemExistente = _pedidoItems.FirstOrDefault(p => p.ProdutoId == pedidoItem.ProdutoId);
                itemExistente.AdicionarUnidades(pedidoItem.Quantidade);
                pedidoItem = itemExistente;

                _pedidoItems.Remove(itemExistente);
            }
            
            _pedidoItems.Add(pedidoItem);
            CalcularValorPedido();
        }

        public static class PedidoFactory
        {
            public static Pedido NovoPedidoRascunho(Guid clienteId)
            {
                var pedido = new Pedido
                {
                    ClienteId = clienteId
                };

                pedido.TornarRascunho();
                return pedido;
            }
        }
    }
}