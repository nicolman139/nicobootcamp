package com.example.rickandmorty.apiRickAndMorty

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

class CharacterViewModel : ViewModel() {
    private val apiService = RickAndMortyApiService.create()

    private val _uiState = MutableStateFlow(CharacterUiState())
    val uiState: StateFlow<CharacterUiState> = _uiState.asStateFlow()

    init {
        loadCharacters()
    }

    fun loadCharacters(page: Int = 1) {
        _uiState.update { it.copy(isLoading = true) }

        viewModelScope.launch {
            try {
                val response = apiService.getCharacters(page)
                _uiState.update {
                    it.copy(
                        characters = it.characters + response.results,
                        isLoading = false,
                        error = null,
                        currentPage = page,
                        totalPages = response.info.pages
                    )
                }
            } catch (e: Exception) {
                _uiState.update {
                    it.copy(
                        isLoading = false,
                        error = e.message ?: "Error desconocido"
                    )
                }
            }
        }
    }

    fun loadMoreCharacters() {
        val nextPage = _uiState.value.currentPage + 1
        if (nextPage <= _uiState.value.totalPages && !_uiState.value.isLoading) {
            loadCharacters(nextPage)
        }
    }
}

data class CharacterUiState(
    val characters: List<Character> = emptyList(),
    val isLoading: Boolean = false,
    val error: String? = null,
    val currentPage: Int = 0,
    val totalPages: Int = 0
)