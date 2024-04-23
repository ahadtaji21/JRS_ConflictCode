﻿using jrs.DBContexts;
using jrs.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ScaffoldModels.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
namespace jrs.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Consumes("application/json")]
    public class MaritalStatusController : ControllerBase
    {
private readonly string _connectionString;
private SqlConnectionStringBuilder sqlConnectionBuilder;
        public MaritalStatusController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("jrsdb");
            sqlConnectionBuilder = new SqlConnectionStringBuilder(_connectionString);

        }
        //IMS.
        [HttpGet]
        public IActionResult Getlist()
        {
            string connectionString = _connectionString;
            var resultList = new List<MaritalStatusView>();
            sqlConnectionBuilder.MultipleActiveResultSets = false;
            using (SqlConnection connection = new SqlConnection(sqlConnectionBuilder.ToString()))
            {
                connection.Open();
                using (SqlCommand command = new SqlCommand($"SELECT * FROM IMS.VI_MaritalStatusList", connection))
                {
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            resultList.Add(new MaritalStatusView
                            {
                                guid_marital_status_id = reader.GetGuid(0),
                                marital_status = reader.GetString(1)
                            });
                        }
                        return Ok(resultList);
                    }
                }
            }
        }
    }
}
