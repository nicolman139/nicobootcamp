package com.example.tocamegame

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Random
import androidx.compose.foundation.clickable

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            TocameGame()
        }
    }
}

@Composable
fun TocameGame() {

    var score by remember { mutableIntStateOf(0) }
    var timeLeft by remember { mutableIntStateOf(30) }
    var isGameActive by remember { mutableStateOf(false) }
    var imagePosition by remember { mutableStateOf(Pair(0, 0)) }
    var username by remember { mutableStateOf("") }
    val random = Random()
    val coroutineScope = rememberCoroutineScope()

    fun moveImage(random: Random) {
        val maxWidth = 300
        val maxHeight = 500
        val newX = random.nextInt(maxWidth)
        val newY = random.nextInt(maxHeight)
        imagePosition = Pair(newX, newY)
    }

    fun startGame() {
        if (username.isEmpty()) {
            return
        }
        score = 0
        timeLeft = 30
        isGameActive = true
        moveImage(random)
        coroutineScope.launch {
            while (timeLeft > 0) {
                delay(1000)
                timeLeft--
            }
            isGameActive = false
        }
    }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {

        BasicTextField(
            value = username,
            onValueChange = { username = it },
            modifier = Modifier
                .fillMaxWidth()
                .padding(8.dp),
            decorationBox = { innerTextField ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    if (username.isEmpty()) {
                        Text(
                            text = "Ingresa tu nombre",
                            color = Color.Gray
                        )
                    }
                    innerTextField()
                }
            }
        )

        Text(
            text = "Puntuación: $score",
            fontSize = 24.sp,
            modifier = Modifier.padding(vertical = 8.dp)
        )

        Text(
            text = "Tiempo: $timeLeft",
            fontSize = 24.sp,
            modifier = Modifier.padding(vertical = 8.dp)
        )

        Button(
            onClick = { startGame() },
            enabled = !isGameActive && username.isNotEmpty()
        ) {
            Text(text = if (isGameActive) "Juego en curso" else "Comenzar Juego")
        }

        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(16.dp)
        ) {
            if (isGameActive) {
                Image(
                    painter = painterResource(id = R.drawable.ic_target),
                    contentDescription = "Imagen para tocar",
                    modifier = Modifier
                        .offset { IntOffset(imagePosition.first, imagePosition.second) }
                        .size(100.dp)
                        .clickable {
                            score++
                            moveImage(random)
                        }
                )
            } else if (timeLeft == 0) {

                Text(
                    text = "$username, tu puntuacion final es: $score",
                    fontSize = 24.sp,
                    modifier = Modifier.align(Alignment.Center)
                )
            }
        }
    }
}