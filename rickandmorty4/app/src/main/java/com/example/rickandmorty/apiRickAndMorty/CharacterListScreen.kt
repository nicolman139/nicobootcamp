package com.example.rickandmorty.apiRickAndMorty

import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.rememberLazyListState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Card
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import coil.compose.rememberAsyncImagePainter
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
@Composable
fun CharacterListScreen(
    viewModel: CharacterViewModel = viewModel()
) {
    val uiState by viewModel.uiState.collectAsState()
    val listState = rememberLazyListState()

    LaunchedEffect(listState) {
        if (listState.layoutInfo.visibleItemsInfo.lastOrNull()?.index ==
            listState.layoutInfo.totalItemsCount - 1) {
            viewModel.loadMoreCharacters()
        }
    }

    Box(modifier = Modifier.fillMaxSize()) {
        if (uiState.isLoading && uiState.characters.isEmpty()) {
            CircularProgressIndicator(modifier = Modifier.align(Alignment.Center))
        } else if (uiState.error != null) {
            Text(
                text = "Error: ${uiState.error}",
                color = Color.Red,
                modifier = Modifier.align(Alignment.Center)
            )
        } else {
            LazyColumn(
                state = listState,
                modifier = Modifier.fillMaxSize()
            ) {
                items(uiState.characters) { character ->
                    CharacterItem(character = character)
                }

                if (uiState.isLoading) {
                    item {
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(16.dp),
                            contentAlignment = Alignment.Center
                        ) {
                            CircularProgressIndicator()
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun CharacterItem(character: Character) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(8.dp),
        shape = RoundedCornerShape(8.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Image(
                painter = rememberAsyncImagePainter(character.image),
                contentDescription = character.name,
                modifier = Modifier
                    .size(80.dp)
                    .clip(CircleShape)
            )

            Spacer(modifier = Modifier.width(16.dp))

            Column {
                Text(
                    text = character.name,
                    style = MaterialTheme.typography.titleMedium,
                    fontWeight = FontWeight.Bold,
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis
                )

                Spacer(modifier = Modifier.height(4.dp))

                Row(verticalAlignment = Alignment.CenterVertically) {

                    Box(
                        modifier = Modifier
                            .size(10.dp)
                            .background(
                                color = when (character.status.lowercase()) {
                                    "alive" -> Color.Green
                                    "dead" -> Color.Red
                                    else -> Color.Gray
                                },
                                shape = CircleShape
                            )
                    )

                    Spacer(modifier = Modifier.width(8.dp))

                    Text(
                        text = "${character.status} - ${character.species}",
                        style = MaterialTheme.typography.bodyMedium,
                        fontSize = 14.sp
                    )
                }

                Spacer(modifier = Modifier.height(4.dp))

                Text(
                    text = "Origin: ${character.origin.name}",
                    style = MaterialTheme.typography.bodySmall,
                    fontSize = 12.sp
                )

                Text(
                    text = "Location: ${character.location.name}",
                    style = MaterialTheme.typography.bodySmall,
                    fontSize = 12.sp
                )
            }
        }
    }
}