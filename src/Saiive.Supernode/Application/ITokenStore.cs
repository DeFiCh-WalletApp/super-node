﻿using System.Threading.Tasks;
using Saiive.SuperNode.Model;

namespace Saiive.SuperNode.Application
{
    public interface ITokenStore
    {
        Task<TokenModel> GetToken(string coin, string network, string tokenName);
    }
}
