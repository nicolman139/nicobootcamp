package com.example.rickandmorty.apiRickAndMorty

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.GET
import retrofit2.http.Query

interface RickAndMortyApiService {
    @GET("character")
    suspend fun getCharacters(
        @Query("page") page: Int = 1
    ): CharacterResponse

    companion object {
        private const val BASE_URL = "https://rickandmortyapi.com/api/"

        fun create(): RickAndMortyApiService {
            val retrofit = Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
            return retrofit.create(RickAndMortyApiService::class.java)
        }
    }
}