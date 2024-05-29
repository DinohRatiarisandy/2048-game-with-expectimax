using Godot;
using System.Collections.Generic;

/*
   This class is responsable of all tile's animations,
   and its deletion in main scene if we don't need it anymore.
*/

public partial class Tile : Node2D
{
   public int value;
   Sprite2D _tileImage;
   readonly Dictionary<int, string> ASSETS = new()
   {
      { 2, "res://Assets/tiles/tile_2.png" },
      { 4, "res://Assets/Tiles/tile_4.png" },
      { 8, "res://Assets/Tiles/tile_8.png" },
      { 16, "res://Assets/Tiles/tile_16.png" },
      { 32, "res://Assets/Tiles/tile_32.png" },
      { 64, "res://Assets/Tiles/tile_64.png" },
      { 128, "res://Assets/Tiles/tile_128.png" },
      { 256, "res://Assets/Tiles/tile_256.png" },
      { 512, "res://Assets/Tiles/tile_512.png" },
      { 1024, "res://Assets/Tiles/tile_1024.png" },
      { 2048, "res://Assets/Tiles/tile_2048.png" },
      { 4096, "res://Assets/Tiles/tile_4096.png" },
      { 8192, "res://Assets/Tiles/tile_8192.png"}
   };

   public override void _Ready()
   {
      _tileImage = GetNode<Sprite2D>("TileImage");
   }

   public void SetImage(int pieceVal)
   {
      _tileImage.Texture = (Texture2D)GD.Load(ASSETS[pieceVal]);
   }

   public void SlideAnim(Vector2 newPos)
   {
      CreateTween().TweenProperty(this, "global_position", newPos, 0.13).SetEase(Tween.EaseType.InOut).SetTrans(Tween.TransitionType.Linear);
   }

   public void SpawnAnim()
   {
      CreateTween().TweenProperty(this, "scale", Vector2.One, 0.13).SetTrans(Tween.TransitionType.Sine).SetEase(Tween.EaseType.InOut);
   }

   public void MergeAnim()
   {
      CreateTween().TweenProperty(this, "scale", Vector2.One, 0.09).SetTrans(Tween.TransitionType.Sine).SetEase(Tween.EaseType.OutIn);
   }

   public void Remove()
   {
      CallDeferred("queue_free");
   }
}